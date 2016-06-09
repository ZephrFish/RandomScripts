#!/bin/bash
if [ -z "$2" ];
then
echo ""
echo "   Usage: ./masslookup.sh urls.txt <dns_ip#53>"
echo ""
else
for i in $(cat $1); do curl -I $i --silent | grep --color -E Server; done
