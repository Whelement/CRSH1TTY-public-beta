#!/bin/bash

main() {
  while $force; do 
    generate_code
    if [ "$fast" != "2" ]; then
      clear
      echo "CRSH1TTY Public Beta #1 - build 1" # just gonna list this as build 1, all subsequent releases will be built off of this haha
    fi
    echo "Trying the code $ac"
    sudo gsctool -t -r "$ac"
    if [ $? -eq 0 ]; then
      force=false
      echo "FOUND IT! Correct code is $ac"
      sleep 1
      read -p "Write down your auth code or take a picture and press enter to continue"
      sleep 2
      echo "Let's check if write protection is actually off"
      sleep 3
      crossystem wpsw_cur # more convenient than flashrom, i swear!!!
      sleep 3
      echo "DM @crossystem about this on Discord and send her the picture."
      sleep 2
      echo "Opening a bash shell for unenrolling..."
      printf 'echo "Unenrolling..."\nflashrom --wp-disable\nflashrom -p ec --wp-disable\nsudo bash /usr/share/vboot/bin/set_gbb_flags.sh 0x80b0\nfutility gbb --set --flash --flags=0x80b0\ncrossystem block_devmode=0\nvpd -i RW_VPD -d block_devmode -d check_enrollment \ncryptohome --action=remove_firmware_management_parameters\necho "attempting unfog"\ntpm_manager_client take_ownership\nchromeos-tpm-recovery'>unenroll.sh
      echo "A unenroll.sh file has been dropped, use bash unenroll.sh to unenroll"
      sleep 1
      sudo bash
      break
    fi
  done
}

# Check if gcstool command is available
if command -v gcstool &> /dev/null; then
    # echo "gcstool is available. Continuing..."
# CRSH1TTY BUILD 1 / BETA #1

# patch notes:
# - none, check back next build (few days / hours)

force=true # why did i name it this lmfaooo

if grep -q "warning: script from noexec mount" "$0"; then
    echo "ignore that warning ^"
fi

read -p "do you want to clear the console each time it tries a code? (y/n): " answer && { [ "$answer" == "y" ] && fast=1 || fast=2; }

generate_code() {
  characters="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  code_length=8

  ac=""
  for ((j=0; j<code_length; j++)); do
    ac+=${characters:$((RANDOM%${#characters})):1}
  done
}

wait
main &
main & 
main & # this is good for public release, right?
else
    echo "gcstool is not available. Exiting..."
    exit 1
fi
