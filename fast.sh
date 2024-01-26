#!/bin/bash

generate_random_code() {
    length=8
    characters="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    code=$(tr -cd "$characters" < /dev/urandom | head -c "$length")
}

gsctoolrma() {
    gsctool -t -r "$code"
}

main() {
    while :; do
        generate_random_code
        echo "Trying the code $code"
        gsctoolrma
        if [ $? -eq 0 ]; then
            echo "Correct code is $code"
            read -p "Write down your auth code or take a picture and press Enter to continue"
            sleep 2
            echo "Let's check if wp is actually off"
            sleep 3
            flashrom -p host --wp-status
            sleep 3
            echo "DM @krossystem about this on Discord"
            break
        else
            echo "Failed, this is a bug, please report"
        fi
    done
}

main
