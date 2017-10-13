#!/bin/bash
# Mutli-Instance iRecon
# mkdir -p  /usr/share/tools/
# git clone https://github.com/ZephrFish/iRecon
# export PATH= /usr/share/tools/iRecon/
for x in $(cat IPs.txt); do iRecon.py $x; done
