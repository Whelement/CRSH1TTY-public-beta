#!/bin/bash

generate_random_code() {
    length=$1
    characters="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    random_code=$(cat /dev/urandom | tr -dc "$characters" | fold -w "$length" | head -n 1)
    echo "$random_code"
}

gsctoolrma() {
    gsctool -t -r "$random_code"
}

main() {
    while true; do
        code=$(generate_random_code 8)
        echo "trying code $code"
        gsctoolrma
        if [ $? -eq 0 ]; then
            echo "correct code $code"
            /usr/share/vboot/bin/set_gbb_flags.sh 0x8090
            echo "correct code $code"
            /bin/bash
            break
        else
            echo "failed"
        fi
    done
}

main
