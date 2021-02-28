#!/bin/bash
# File Checker
# A quick script for checking a list of IPs or URLs for a specific file
# Usage: ./FileChecker.sh <targetsFile> <fileToLookFor>
# Example: ./FileChecker.sh targets.txt phpinfo.php

for x in $(<$1);
do
if curl --output /dev/null --head --silent --fail "$x/$2";
then
echo "URL exists: $x/$2"
echo "$x/$2" | httprobe >> ValidURLs.txt
else
echo "URL does not exist: $x/$2"
fi;
done
