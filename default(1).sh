#!/bin/bash

#This script is currently the default. It was created by unrealgamertwentyone.

#This script randomly generates a 8 character string from all the capatal letters and numbers, it then compares it to the cr50's auth code.
#Though the random generation seems slow due to not checking for repeated codes, it calculates and compares codes very quickly, making it the fastest we currently have.

RMA_SERVER="https://www.google.com/chromeos/partner/console/cr50reset"
USER_MAX_RETRIES=1
BRUTE_FORCE_MAX_RETRIES=-1

unenroll() {
  echo "Unenrolling..."
  flashrom --wp-disable
  flashrom -p ec --wp-disable
  sudo bash /usr/share/vboot/bin/set_gbb_flags.sh 0x80b0
  futility gbb --set --flash --flags=0x80b0
  crossystem block_devmode=0
  vpd -i RW_VPD -d block_devmode -d check_enrollment 
  cryptohome --action=remove_firmware_management_parameters
  echo "attempting unfog"
  tpm_manager_client take_ownership
  chromeos-tpm-recovery
}

brute_force_reset() {
  characters="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  code_length=8
  attempts=0

  while true; do
    ac=""
    for ((j=0; j<code_length; j++)); do
      ac+=${characters:$((RANDOM%${#characters})):1}
    done

    ac_uppercase=$(echo "${ac}" | tr 'a-z' 'A-Z')

    if gsctool -t -r "${ac_uppercase}"; then
      echo "It... found the code?! Impossible! Take a screenshot and make an issue in the github or send it via DM to discord user unrealgamertwentyone or thetechfrog!"
      echo "include this information in your screenshot:"
      echo "Working code: ${ac_uppercase}"
      echo "HWID: ${hwid}"
      echo "Challenge: ${ch}"
      sleep 5
      read -p "Press enter to continue, or in other words, attempt to unenroll. Hope this works..."
      echo "Unenrollment in progress..."
      sleep 2
      unenroll
      echo "Unenrollment successful!??!?!?!? (you may have to boot into verified mode then go through setup to enable dev mode)"
      reboot
      sleep 1d
      exit 0
    fi

    echo "trying ${ac}"
    : $(( attempts += 1 ))

    if [ ${attempts} -eq ${BRUTE_FORCE_MAX_RETRIES} ]; then
      break
    fi
  done
}

cr50_reset() {

  if ! command -v gsctool > /dev/null; then
    echo "gsctool is not installed."
    return 1
  fi

  hwid=$(crossystem hwid 2>/dev/null | sed -e 's/ /_/g')
  ch=$(gsctool -t -r | sed -e 's/.*://g')

  if [ -z "${ch}" ]; then
    echo "Challenge wasn't generated. CR50 might need updating."
    return 1
  fi

  ch=$(echo "${ch}" | tr -d '[:space:]')
  chstr="${RMA_SERVER}?challenge=${ch}&hwid=${hwid}"

  clear
  echo "Welcome to CRSH1TTY! To begin, press enter. This will take... a long time. Leave your chromebook running for as long as you can."
  echo "Extra info, just in case you need it:"
  echo "HWID: ${hwid}"
  echo "URL: ${chstr}"
  echo "Challenge: ${ch}"
  echo "check the list of challenge to auth codes to see if the challenge mentioned above is listed, if it is, type in the matching auth code now."

  n=0
  while [ ${n} -lt ${USER_MAX_RETRIES} ]; do
    stty olcuc
    read -e ac
    stty -olcuc

    ac_uppercase=$(echo "${ac}" | tr 'a-z' 'A-Z')

    if gsctool -t -r "${ac_uppercase}"; then
      echo "You... found the code?! Impossible! Take a screenshot and create an issue in the github or send it via DM to discord user unrealgamertwentyone or thetechfrog!"
      echo "include this information in your screenshot:"
      echo "Working code: ${ac_uppercase}"
      echo "HWID: ${hwid}"
      echo "Challenge: ${ch}"
      sleep 5
      read -p "Press enter to continue, or in other words, attempt to unenroll. Hope this works..."
      echo "Unenrollment in progress..."
      sleep 2
      unenroll
      echo "Unenrollment successful!??!?!?!? (you may have to boot into verified mode then go through setup to enable dev mode)"
      reboot
      sleep 1d
      exit 0
    fi

    : $(( n += 1 ))
    if [ ${n} -eq ${USER_MAX_RETRIES} ]; then
      echo "Starting bruteforcer..."
      sleep 1
      brute_force_reset
      if [ $? -ne 0 ]; then
        echo "An error occurred! Please restart the script."
      fi
    fi
  done

  read -p "Press enter to continue"
}

main() {
  while true; do
    cr50_reset
    if [ $? -ne 0 ]; then
      echo "Cr50 Reset Error."
      exit 1
    fi
    read -p "Press enter to start brute force..."

    brute_force_reset
    if [ $? -ne 0 ]; then
      echo "An error occurred! Please restart the script."
      exit 1
    fi
  done
}

main "$@"
