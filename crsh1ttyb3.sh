#!/bin/bash

unenroll() {
flashrom --wp-disable
/usr/share/vboot/bin/set_gbb_flags.sh 0x80b0
chromeos-tpm-recovery
vpd -i RW_VPD -s check_enrollment=0
vpd -i RW_VPD -s block_devmode=0
tpm_manager_client take_ownership
cryptohome --action=remove_firmware_management_parameters
}

gencode() {
    characters="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    code_length=8
    ac=$(for ((i=0; i<code_length; i++)); do echo -n "${characters:RANDOM%${#characters}:1}"; done)
}

process() {
    while true; do
        gencode
        sudo gsctool -t -r "$ac" && {
            echo "Auth code found, sleeping for 10 seconds before unenrolling, removing the fog, and setting gbb flags."
            sleep 10
            unenroll
            sudo bash
        }
    done
}

main() {
    local sub=$1

    for ((i=0; i<sub; i++)); do
        (
            process
        ) &
    done
    wait
}

read -rp "WARNING! You cannot terminate the script if you run 6 or more subprocesses!
However, I recommend running 50-200 subprocesses, for maximum efficiency.
Enter the number of subprocesses to run: " sub

main "$sub"
