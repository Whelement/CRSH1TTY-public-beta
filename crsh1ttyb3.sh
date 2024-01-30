#!/bin/bash

gbb() {
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
            echo "Auth code found, sleeping for 10 seconds before setting flags"
            sleep 10
            gbb
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
