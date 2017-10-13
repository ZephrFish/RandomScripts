#!/bin/bash
# Because For Loops are beautiful
# When Zephr got bored one day
for y in $(wget https://bugbountyforum.com/tools/ &&  grep "/tools/" index.html | cut -d "=" -f 2 | cut -d "/" -f 2,3 | grep -v ">"); do wget https://bugbountyforum.com/$y; done && for x in $(ls); do grep "href=" $x | cut -d "=" -f 2 | grep github.com | cut -d "/" -f 3,4,5 | cut -d " " -f 1 |sed -e 's/^"//' -e 's/"$//' | grep -v "gist" >> Repos.txt; done && for a in $(cat Repos.txt);do git clone https://$a; done && find . -maxdepth 1 -type f -delete
