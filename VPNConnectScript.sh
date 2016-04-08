# !/bin/bash
# ZephrFish Anonine VPN Connect Script
#
#
# Internet Check
# Checks if machine has internet access via pinging google.com

# Declare Colour Variables
b='\033[1m'
u='\033[4m'
r='\E[31m'
g='\E[32m'
y='\E[33m'
m='\E[35m'
c='\E[36m'
w='\E[37m'
endc='\E[0m'
enda='\033[0m'

function checkinternet() {
  ping -c 1 google.com > /dev/null
  if [[ "$?" != 0 ]]
  then
    echo -e " Checking For Internet: ${r}FAILED${endc}
 ${y}You're Using a Fucking VPN Script and You have no Internet, That is enough internet for you today${endc}"
    echo -e " ${b}Rerun When Not So Retarded${enda} I am away"
    echo && sleep 2
    kexit
  else
    echo -e " Checking For Internet: ${g}PASSED${endc}"
  fi
}

checkinternet
# Root Check
# Checks if script is being run as sudo or root based upon username; will change in future to UID based
function rootcheck() {
if [[ $USER != "root" ]] ; then
                echo "Please Note: This script must be run as root!"
                exit 1
        fi
echo -e " Checking For Root or Sudo: ${g}PASSED${endc}"
}



# VPN Locations Menu
# Carry out rootcheck first before running
rootcheck
# Make sure to change the path to configs and also within configs add your own auth details to allow for background running
echo "######################################################"
echo "##               VPN Connect Script                 ##"
echo "######################################################"
echo ""
echo ""
echo "Please Select from the Following optinos what server you want to connect to"
PS3='What server would you like to connect to?: '
options=("Amsterdam" "Atlanta" "Coventry" "Miami" "Moscow" "Oslo" "Paris" "Stockholm" "Sydney" "Toronto" "Zurich" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Amsterdam")
             openvpn --config /usr/vpnconf/Amsterdam.ovpn&
            ;;
        "Atlanta")
             openvpn --config /usr/vpnconf/Atlanta.ovpn&
            ;;
        "Coventry")
             openvpn --config /usr/vpnconf/Coventry.ovpn&
            ;;
	"Miami")
             openvpn --config /usr/vpnconf/Miami.ovpn&
	    ;;
	"Moscow")
	     openvpn --config /usr/vpnconf/Moscow.ovpn&
	    ;;
	"Oslo")
	     openvpn --config /usr/vpnconf/Oslo.ovpn&
	    ;;
	"Paris")
	     openvpn --config /usr/vpnconf/Paris.ovpn&
	    ;;
	"Stockholm")
	     openvpn --config /usr/vpnconf/Stockholm.ovpn&
	    ;;
	"Sydney")
	   openvpn --config /usr/vpnconf/Sydney.ovpn&
	  ;;
	"Toronto")
	   openvpn --config /usr/vpnconf/Toronto.ovpn&
	  ;;
	"Zurich")
	   openvpn --config /usr/vpnconf/Zurich.ovpn&
          ;;
        "Quit")
            break
            ;;
        *) echo "invalid option, please try again";;
    esac
done
