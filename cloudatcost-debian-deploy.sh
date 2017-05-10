#!/bin/bash
# Debian Build Script 
# Cloud at Cost
# ZephrFish
echo "[+] Enter a username to start deploying"
adduser $1
echo "[+] Debian Deploy Script"
rm -rf /etc/apt/sources.list
touch /etc/apt/sources.list
echo "# Debian 9" >> /etc/apt/sources.list
echo "deb http://ftp.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://ftp.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list
echo "deb http://ftp.debian.org/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://ftp.debian.org/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list
echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
sudo gpg --keyserver pgpkeys.mit.edu --recv-key  7D8D0BF6
sudo gpg -a --export 7D8D0BF6 | sudo apt-key add -
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
apt install sudo wget curl git zip ccze byobu zsh -y
gpasswd -a $1 sudo
pvscan && vgextend localhost-vg /dev/sda3 && lvextend -l +100%FREE /dev/localhost-vg/root && resize2fs /dev/localhost-vg/root
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
