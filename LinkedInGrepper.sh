#!/bin/bash
grep 'org-people-profile-card__profile-title t-black lt-line-clamp lt-line-clamp--single-line ember-view' LinkedIn.html  | cut -d ">" -f 2 | sed 's/^ //g' | sort -u | uniq > names.txt
# https://github.com/ZephrFish/RandomScripts/blob/master/namesmash.py 
python3 namesmash.py names.txt
