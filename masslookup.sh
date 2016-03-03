#!/bin/bash
# Mass NSLookup Script
# Where $1 = list of domain names & $2 = your dns server#53
if [ -z "$2" ];
then
echo ""
echo "   Usage: ./masslookup.sh urls.txt <dns_ip#53>"
echo ""
else
for ip in $(cat $1); do nslookup $ip | grep Address: | cut -d ":" -f 2| sort| uniq | grep -v
"$2"; done
