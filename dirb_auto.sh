#!/bin/bash
# Dirb Automation with multiple targets
# Requirements:
#  screen, dirb, some targets in a file
# ZephrFish 2016
# Work In Progress
# Detect if running as root
if [[ "$EUID" -ne 0 ]]; then
        echo "Sorry, you need to run this as root"
        exit 2
fi
# Check for requirements, if not installed, install them
if [[ ! -e /usr/bin/screen || ! -e /usr/bin/dirb ]]; then
        echo "You need screen & dirb for this to work"
        read -p "Do you want to go ahead and install the requirements? [y/n]: " -e -i INSTALL
                if [[ "$INSTALL" = 'y' ]]; then
                        apt-get update -y
                        apt-get install screen dirb -y
                else
                        echo "[!] Requirements not installed, exiting as requested"
                        exit 3
                fi
fi

# Check if user has supplied a targets file
if [ "$#" -ne 1 ]; then
  echo ""
  echo " Usage: ./dirb_auto.sh targets.txt"
  echo ""
exit 4
fi


echo "[+] Dirb Automation Script"
echo "[!] ZephrFish 2016"

# Set our targets file
targets=$1

# Set the total number of screen sessions required
total_screen=$(wc -l $targets | cut -d " " -f 1)

# Some hackery to check if targets have http/https in file
# Fuckit if this doesn't work
if  grep -R "http\|https" "$targets" > /dev/null; then
    # Continuing
        echo " "
        echo "All good"
else
        echo "[!] Make sure your targets file has http or https in front of each target"
        exit 5


fi

# Trying to work out best way to pass commands to each screen session
#for x in $(seq 1 $total_screen); do screen -dmS $x-dirb; done
#for t in $(cat $targets); do for z in $(seq 1 $total_screen); do echo $z "+" $t | sort -u; done; done
#for t in $(cat $targets); do screen -S $x-dirb -X stuff 'dirb $t'$(echo -ne '\015'); done

for x in $(seq 1 $total_screen); do screen -dmS $x-dirb; done

# Now we send the attacks
for t in $(cat $targets); do screen -S $x-dirb -X stuff 'dirb $t -w -S -f -o /tmp/$RANDOM-Dirb'$(echo -ne '\015'); done

echo "Done :-)"
