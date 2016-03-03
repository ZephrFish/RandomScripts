#!/bin/bash
# Kali Setup Script
# Version: 0.1
# Creators: ZephrFish & Bootloader

# Declare Variables -- each variable sets a colour against statements
b='\033[1m'
u='\033[4m'
bl='\E[30m'
r='\E[31m'
g='\E[32m'
y='\E[33m'
bu='\E[34m'
m='\E[35m'
c='\E[36m'
w='\E[37m'
endc='\E[0m'
enda='\033[0m'

# Functions for Root, Internet, Accepting and Pause
function pause()
{
   read -p "$*"
}

# Prints out the information about what OS this has been tested on and what the script is used for
function disclaimer(){
echo -e "This script has been created to setup a "
}

# Check Internet Script
function checkinternet() {
  ping -c 1 google.com > /dev/null
  if [[ "$?" != 0 ]]
  then
    echo -e " Checking For Internet: ${r}FAILED${endc}
 ${y}Please Check Your COnnection${endc}"
    echo -e " ${b}Rerun When Connection is fixed${enda} I am away"
    echo && sleep 2
    kexit
  else
    echo -e " Checking For Internet: ${g}PASSED${endc}"
  fi
}
 
# Root Check
function rootcheck() {
if [[ $USER != "root" ]] ; then
                echo "Please Note: This script must be run as root!"
                exit 1
        fi
echo -e " Checking For Root or Sudo: ${g}PASSED${endc}"
}

echo -e "Kali Setup Script"

# Initial System Update
function initupd {
  echo && echo -e " ${y}Preparing To Perform Updates${endc}"
  echo " It Is Recommended To Perform a system update"
  echo " Prior to installing Any Application."
  echo -en " ${y}Would You Like To Perform Apt-Get Update Now ? {y/n}${endc} "
  read option
  case $option in
    y) echo; echo " Performing Apt-Get Update"; apt-get -y update && apt-get upgrade -y; echo " Apt-Get Update Completed"; sleep 1 ;;
    n) echo " Skipping Update for the moment"; sleep 1 ;;
    *) echo " \"$option\" Is Not A Valid Option"; sleep 1; initupd ;;
  esac
}

# Install Emacs function
function i-emacs {
  echo
  echo -e " Currently Installing ${b}Emacs${enda}"
  echo -e " ${bu}GNU Emacs is an extensible, customizable text editor—and
 more. At its core is an interpreter for Emacs Lisp,
 a dialect of the Lisp programming language with
 extensions to support text editing.
 Read more about it here: ${b}http://www.gnu.org/software/emacs/${endc}"
  echo && echo -en " ${y}Press Enter To Continue${endc}"
  read input
  echo -e " Installing ${b}Emacs${enda}"
  apt-get -y install emacs
  echo -e " ${b}Emacs${enda} Was Successfully Installed"
  echo && echo " Run Emacs From ${b}Programming${endc}"
  echo -en " ${y}Press Enter To Return To Menu${endc}"
  echo
  read input
}

# Kali Basic Tools
function kbasic() {
echo "Installing Kali Basic Tools"
apt-get install -y nmap netcat tar terminator netcat fail2ban whois aircrack-ng virtualbox git subversion traceroute mtr wine ngerp apache2 wireshark tshark bluefish zenmap hydra john nbtscan  tcpdump openjdk-6-jre openjdk-7-jre openvpn ettercap-text-only ettercap-graphical nikto kismet sslscan onesixyone ghex bless pidgin pidgin-otr lft powertop rdesktop rlogin ruby rubygems bcrypt reaver unrar chkrootkit rkhunter nbtscan wireshark tcpdump openjdk-7-jre openvpn ettercap-text-only ghex pidgin pidgin-otr traceroute lft gparted autopsy subversion git gnupg htop ssh libimage-exiftool-perl aptitude p7zip-full proxychains curl terminator irssi gnome-tweak-tool libtool build-essential bum rdesktop sshfs bzip2 extundelete gimp iw ldap-utils ntfs-3g samba-common samba-common-bin steghide whois python-dev libpcap-dev aircrack-ng gnome-screenshot eog bundler ruby1.9.1 ruby1.9.1-dev libssl1.0.0 libssl-dev laptop-mode-tools python-nfqueue python-scapy openconnect libgmp3-dev libpcap-dev gengetopt byacc flex cmake libpcre3-dev libidn11-dev ophcrack gdb stunnel socat libcurl4-openssl-dev chromium-browser swftools hping3 tcpreplay tcpick python-setuptools gufw vncviewer python-urllib3 libnss3-1d libxss1 scalpel foremost unrar rar secure-delete vmfs-tools
apt-get remove -y --purge rhythmbox ekiga totem* ubuntu-one* unity-lens-music unity-lens-friends unity-lens-photos unity-lens-video transmission* thunderbird* apport

# Disable remote and guest login, only applicable to ubuntu based systems
sh -c 'printf "[SeatDefaults]\ngreeter-show-remote-login=false\n" >/usr/share/lightdm/lightdm.conf.d/50-no-remote-login.conf'
sh -c 'printf "[SeatDefaults]\nallow-guest=false\n" >/usr/share/lightdm/lightdm.conf.d/50-no-guest.conf'

###########################################################################################################################################
mkdir ~/$mydirectory/cheatsheets
mkdir ~/$mydirectory/exploits
cd ~/$mydirectory/exploits

echo "installation of android sdk"
mkdir ~/$mydirectory/mobile
cd ~/$mydirectory/mobile
wget -nc http://dl.google.com/android/android-sdk_r22.6-linux.tgz
tar -xvf android-sdk_r22.6-linux.tgz
rm -rf android-sdk_r22.6-linux.tgz
cd ~/$mydirectory

** metasploit

echo "gather the metasploit repository"
cd ~/$mydirectory/exploits
git clone https://github.com/rapid7/metasploit-framework.git
cd ~/$mydirectory/exploits/metasploit-framework

echo "installation of metasploit requirements"
apt-get install -y build-essential libreadline-dev libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev openjdk-7-jre subversion git-core autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev libyaml-dev ruby1.9.3 nmap

echo "installation of metasploit required gems"
gem install wirble sqlite3 bundler rake
bundle install

echo "wordlists gathering"
cd ~/
mkdir ~/$mydirectory/wordlists
cd ~/$mydirectory/wordlists
wget -nc http://downloads.skullsecurity.org/passwords/rockyou.txt.bz2

echo "install burp"
cd ~/$mydirectory
mkdir ~/$mydirectory/webapps
mkdir ~/$mydirectory/webapps/burp_proxy
cd ~/$mydirectory/webapps/burp_proxy
wget -nc http://portswigger.net/burp/burpsuite_free_v1.6.jar
cd ~/$mydirectory

echo "install cookie cadger"
mkdir ~/$mydirectory/network
mkdir ~/$mydirectory/network/sidejacking
cd ~/$mydirectory/network/sidejacking
wget -nc https://www.cookiecadger.com/files/CookieCadger-1.06.jar
cd ~/$mydirectory
** enum4
echo "install enum4linux"
mkdir ~/$mydirectory/network/enum4linux
cd ~/$mydirectory/network/enum4linux
wget https://labs.portcullis.co.uk/download/enum4linux-0.8.9.tar.gz
tar -xvf enum4linux-0.8.9.tar.gz
rm -rf enum4linux-0.8.9.tar.gz
cd ~/$mydirectory

echo "install torbrowser"
#darknet tor
mkdir ~/$mydirectory/network/torbrowser
cd ~/$mydirectory/network/torbrowser
wget -nc https://www.torproject.org/dist/torbrowser/3.5/tor-browser-linux64-3.5_en-US.tar.xz
tar -xvf tor-browser-linux64-3.5_en-US.tar.xz
rm -rf tor-browser-linux64-3.5_en-US.tar.xz
cd ~/$mydirectory

echo "gathering phpreverseshell"
mkdir ~/$mydirectory/network/reverse_shells
cd ~/$mydirectory/network/reverse_shells
wget -nc http://pentestmonkey.net/tools/php-reverse-shell/php-reverse-shell-1.0.tar.gz
tar -xvf ~/$mydirectory/network/reverse_shells/php-reverse-shell-1.0.tar.gz
rm -rf ~/$mydirectory/network/reverse_shells/php-reverse-shell-1.0.tar.gz
cd ~/$mydirectory

#wcedigest
echo "install wcedigest"
mkdir ~/$mydirectory/escalation
mkdir ~/$mydirectory/escalation/wcedigest
cd ~/$mydirectory/escalation/wcedigest
wget -nc http://www.ampliasecurity.com/research/wce_v1_3beta.tgz
tar -xvf wce_v1_3beta.tgz
rm -rf wce_v1_3beta.tgz
cd ~/$mydirectory

#mimikatz
echo "install mimikatz"
mkdir ~/$mydirectory/escalation/mimikatz
cd ~/$mydirectory/escalation/mimikatz
wget -nc http://blog.gentilkiwi.com/downloads/mimikatz_trunk.zip
unzip -o mimikatz_trunk.zip
rm -rf mimikatz_trunk.zip
cd ~/$mydirectory
** forensics tools
#memory forensics tools
echo "install volatility framework"
mkdir ~/$mydirectory/forensics
mkdir ~/$mydirectory/forensics/volatility
cd ~/$mydirectory/forensics/volatility
wget -nc https://volatility.googlecode.com/files/volatility-2.3.1.tar.gz
cd ~/$mydirectory/forensics/volatility
tar -xvf volatility-2.3.1.tar.gz
rm -rf volatility-2.3.1.tar.gz
cd ~/$mydirectory

#recon dns
echo "install DNSmap"
mkdir ~/$mydirectory/recon
mkdir ~/$mydirectory/recon/dnsmap
cd ~/$mydirectory/recon/dnsmap
wget -nc https://dnsmap.googlecode.com/files/dnsmap-0.30.tar.gz
tar -xvf dnsmap-0.30.tar.gz
rm -rf dnsmap-0.30.tar.gz
cd ~/$mydirectory


#webapp vulnerability assessors
echo "install subgraph vega"
mkdir ~/$mydirectory/webapps/vega
cd ~/$mydirectory/webapps/vega
wget -nc http://subgraph.com/downloads/VegaBuild-linux.gtk.x86_64.zip
unzip -o VegaBuild-linux.gtk.x86_64.zip
rm -rf VegaBuild-linux.gtk.x86_64.zip
cd ~/$mydirectory

echo "install oclhashcat"
mkdir ~/$mydirectory/pwcracking
mkdir ~/$mydirectory/pwcracking/oclhashcat
cd ~/$mydirectory/pwcracking/oclhashcat
wget -nc http://hashcat.net/files/oclHashcat-1.01.7z
p7z oclHashcat-1.01.7z
rm -rf oclHashcat-1.01.7z
cd ~/$mydirectory

echo "install cryptohaze multiforcer needs opencl"
mkdir ~/$mydirectory/pwcracking/cryptohaze_multiforcer
cd ~/$mydirectory/pwcracking/cryptohaze_multiforcer
wget -nc "http://downloads.sourceforge.net/project/cryptohaze/New-Multiforcer-Linux_x64_1_31.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fcryptohaze%2Ffiles%2F&ts=1391475227&use_mirror=superb-dca2" -O New-Multiforcer-Linux_x64_1_31.tar.bz2
bunzip -o2 New-Multiforcer-Linux_x64_1_31.tar.bz2
tar -xvf New-Multiforcer-Linux_x64_1_31.tar.bz2
rm -rf New-Multiforcer-Linux_x64_1_31.tar.bz2
cd ~/$mydirectory

#Multiple web-backdoors
echo "install fuzzdb"
mkdir ~/$mydirectory/webapps/fuzzdb
cd ~/$mydirectory/webapps/fuzzdb
svn checkout http://fuzzdb.googlecode.com/svn/trunk/ fuzzdb-read-only
cd ~/$mydirectory

#web-app tools
echo "install sqlmap and other tools from github"
cd ~/$mydirectory/webapps
git clone https://github.com/vs4vijay/heartbleed.git
git clone https://github.com/beefproject/beef
git clone https://github.com/Arachni/arachni.git
cd ~/$mydirectory/webapps/arachni
bundle install
cd ~/$mydirectory/webapps
git clone https://github.com/wpscanteam/wpscan.git
git clone https://github.com/sullo/nikto.git
git clone https://github.com/gabtremblay/tachyon.git
git clone https://github.com/sqlmapproject/sqlmap.git
cd ~/$mydirectory

#tools for social engineering
mkdir ~/$mydirectory/social_engineering
cd ~/$mydirectory/social_engineering
git clone https://github.com/trustedsec/social-engineer-toolkit.git
cd ~/$mydirectory

#tools for mitm/network (yersinia to test)
cd ~/$mydirectory/network/
git clone https://github.com/DanMcInerney/creds.py.git
git clone https://github.com/nccgroup/vlan-hopping.git
git clone https://github.com/tomac/yersinia.git
git clone https://github.com/Hood3dRob1n/Reverser.git
cd ~/$mydirectory

#VulnDB
mkdir ~/$mydirectory/vulndb
cd ~/$mydirectory/vulndb
git clone https://github.com/toolswatch/vFeed.git
cd ~/$mydirectory

#all the exploits from exploit-db
cd ~/$mydirectory/exploits
git clone https://github.com/offensive-security/exploit-database
cd ~/$mydirectory

#tools for privescalation
cd ~/$mydirectory/escalation
git clone https://github.com/pentestgeek/smbexec.git
git clone https://github.com/rebootuser/LinEnum.git
cd ~/$mydirectory

#framework veil ASM
cd ~/$mydirectory/exploits
git clone https://github.com/Veil-Framework/Veil-Evasion.git

#tools for mitm lan
cd ~/$mydirectory/network
git clone https://github.com/DanMcInerney/LANs.py.git
git clone https://github.com/SpiderLabs/Responder.git
cd ~/$mydirectory

#recon
cd ~/$mydirectory/recon
git clone https://github.com/hatRiot/clusterd.git
cd ~/$mydirectory

#cheatsheets
cd ~/$mydirectory/cheatsheets
git clone https://github.com/aramosf/sqlmap-cheatsheet.git
cd ~/$mydirectory

#portscanners
cd ~/$mydirectory/network
git clone git://github.com/zmap/zmap.git
cd ~/$mydirectory/network/zmap
cmake -DENABLE_HARDENING=ON
make
make install
cd ~/$mydirectory

#tools to ident hash
mkdir ~/$mydirectory/crypto
cd ~/$mydirectory/crypto
git clone https://github.com/SmeegeSec/HashTag.git
cd ~/$mydirectory

#tools for passthehash
cd ~/$mydirectory/network
git clone https://github.com/inquisb/keimpx
cd ~/$mydirectory

#tools for mitm vlan hop
cd ~/$mydirectory/network
git clone https://github.com/nccgroup/vlan-hopping.git
cd ~/$mydirectory

#tools for portscanning
cd ~/$mydirectory/network
git clone https://github.com/robertdavidgraham/masscan.git
cd ~/$mydirectory

#tools for recon
cd ~/$mydirectory/recon
git clone https://github.com/urbanadventurer/WhatWeb.git
cd ~/$mydirectory

#xss web-app
cd ~/$mydirectory/webapps
git clone https://github.com/spinkham/skipfish.git
cd ~/$mydirectory/webapps/skipfish
sudo make
git clone https://github.com/mandatoryprogrammer/xssless.git
cd ~/$mydirectory

#wifi et wps
mkdir ~/$mydirectory/wireless
cd ~/$mydirectory/wireless
git clone https://github.com/DanMcInerney/wifijammer.git
git clone https://github.com/derv82/wifite.git
git clone https://github.com/bdpurcell/bully.git
cd ~/$mydirectory/wireless/bully/src
make
make install
cd ~/$mydirectory

echo "masscan"
cd ~/$mydirectory/network/masscan
make
cd ~/$mydirectory

echo "requirements for wpscan"
cd ~/$mydirectory/webapps/wpscan
bundle install
cd ~/$mydirectory

echo "install WSattacker"
mkdir ~/$mydirectory/webapps/ws_attacker
cd ~/$mydirectory/webapps/ws_attacker
wget -nc "http://downloads.sourceforge.net/project/ws-attacker/WS-Attacker%201.3/WS-Attacker-1.3.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fws-attacker%2F&ts=1391476709&use_mirror=iweb" -O WS-Attacker-1.3.zip
unzip -o WS-Attacker-1.3.zip
rm -rf WS-Attacker-1.3.zip
cd ~/$mydirectory

echo "OWASP ZAP"
mkdir ~/$mydirectory/webapps/zap_proxy
cd ~/$mydirectory/webapps/zap_proxy
wget -nc "http://downloads.sourceforge.net/project/zaproxy/2.3.0/ZAP_2.3.0.1_Linux.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fzaproxy%2Ffiles%2F2.3.0%2F&ts=1397474662&use_mirror=iweb" -O ZAP_2.3.0.1_Linux.tar.gz
tar -xvf ZAP_2.3.0.1_Linux.tar.gz
rm -rf ZAP_2.3.0.1_Linux.tar.gz
cd ~/$mydirectory

echo "windows tools just in case no internets"
mkdir ~/$mydirectory/windows
mkdir ~/$mydirectory/windows/win_tools
cd ~/$mydirectory/windows/win_tools
wget -nc http://www.oxid.it/downloads/ca_setup.exe
wget -nc http://www.ollydbg.de/odbg200.zip
wget -nc http://www.ollydbg.de/odbg110.zip
wget -nc http://out7.hex-rays.com/files/idafree50.exe


echo "correcting user-rights"
cd ~/
clear
chown -R $myname:$myname ~/$mydirectory

echo "clean packages downloaded"
* what web
wget www.morningstarsecurity.com/downloads/whatweb-0.4.7.tar.gz
gunzip whatweb-0.4.7.tar.gz
tar -xvf whatweb-0.4.7.tar.gz
zap??
ikescan
 burpsuite amap vim sqlmap
}


function installchromium {
  getggrep="/etc/apt/sources.list.d/google.list"
  echo -e " Preparing To Install ${b}Chromium${enda}" && echo
  echo -e " ${bu}Chromium is an open-source browser project that aims to build
 a safer, faster, and more stable way for all Internet
 users to experience the web. This site contains design
 documents, architecture overviews, testing information,
 and more to help you learn to build and work with the
 Chromium source code.
 Read more about it here: ${b}http://www.chromium.org/Home${enda}"
  echo && echo -en " ${y}Press Enter To Continue${endc}"
  read input
  echo -e " Installing ${b}Chromium${enda}"
  if [[ -d $getggrep ]]; then
    echo -e " ${b}Google Linux Repository${enda} status: ${g}Installed${endc}"
    apt-get install chromium
    wget http://sourceforge.net/projects/kaais/files/Custom_Files/chromium -O /usr/bin/chromium
  else
    echo -e " ${b}Google Linux Repository${enda} status: ${r}Not Found${endc}"
    echo -e " Installing ${b}Google Linux Repository${enda}"
    wget -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
    apt-get update
    echo -e " ${b}Google Linux Repository${enda} is now installed"
    apt-get install chromium
    wget http://sourceforge.net/projects/kaais/files/Custom_Files/chromium -O /usr/bin/chromium
  fi
  echo -e " ${b}Chromium${enda} Was Successfully Installed"
  echo && echo -e " Run Chromium From The ${b}Internet${enda} Menu"
  echo && echo -en " ${y}Press Enter To Return To Menu${endc}"
  read input
}

rootcheck
checkinternet
initupd


# Kali Install Menu
# Has options to setup a non-kali OS and make it more security testing friendly
echo "Please Select from the Following optinos what applications you'd like to install"
PS3='What Applications would you like to install?: '
options=("Basics" "Extras" "Everything" "Choose Each Option" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Basics")
             # Installs basic tools that will make a ubuntu or debian based distro more kali like
                i-emacs
                kbasic
                installchromium
            ;;
        "Extras")
             # Install Extra applications and fixes for Kali 2.0
            ;;
        "Everything")
             # Install All the things!
            ;;
        "Choose Each Option")
             # Have all Pause functions included
             #
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option, please try again";;
    esac
done
Thu Feb 11 13:28:00 root
