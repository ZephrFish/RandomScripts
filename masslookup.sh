#!/bin/bash
# Mass NSLookup Script

for ip in $(cat $1); do nslookup $ip | grep Address: | cut -d ":" -f 2| sort| uniq | grep -v
"$2"; done
