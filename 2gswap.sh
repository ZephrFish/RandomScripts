#!/bin/bash
# Allocate swap space for VPS
echo "[*] Swap Setup for VPS with 512mb... [*]"
swapon -s
dd if=/dev/zero of=/swapfile bs=1024 count=2048k
mkswap /swapfile
swapon /swapfile
echo 10 | sudo tee /proc/sys/vm/swappiness
echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf
chown root:root /swapfile 
chmod 0600 /swapfile
echo "[*] Swap Setup Complete... [*]"
