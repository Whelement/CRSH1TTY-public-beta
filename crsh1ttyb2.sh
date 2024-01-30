#!/bin/bash

gencode() {
    characters="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    code_length=8
    ac=$(for ((i=0; i<code_length; i++)); do echo -n "${characters:RANDOM%${#characters}:1}"; done)
}

process() {
    while true; do
        gencode
        sudo gsctool -t -r "$ac" && {
            echo "Auth code found"
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
Enter the number of subprocesses to run: " sub

main "$sub"
