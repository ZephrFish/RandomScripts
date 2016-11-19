#!/bin/bash
# OpenVPN Debian Deployment Script
# ZephrFish
# Mishmash of scripts, parts from Road Warrior OpenVPN(https://github.com/Nyr/openvpn-install), parts from Deployment Script(https://github.com/ZephrFish/RandomScripts/blob/master/cloudatcost-debian-deploy.sh)
# Other parts purely written :-)
# Enjoy
# The MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

echo "[+] Debian Deploy Script"
echo "Sets up a user, installs and deploys openvpn"
# Add a user for later use
useradd amnesia
# recreate sources.list file and append Debian testing sources
rm -rf /etc/apt/sources.list
touch /etc/apt/sources.list
echo "# Debian 9" >> /etc/apt/sources.list
echo "deb http://ftp.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://ftp.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list
echo "deb http://ftp.debian.org/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://ftp.debian.org/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list
apt-get update
# Update, Upgrade and Upgrade distrobution
apt-get upgrade -y
apt-get dist-upgrade -y
apt install openvpn sudo wget curl git zip
gpasswd -a amnesia sudo
# Easier VPN Deployment credit(https://github.com/Nyr)
wget https://git.io/vpn -O openvpn-install.sh && bash openvpn-install.sh
