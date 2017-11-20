#!/bin/bash
dates=$(echo "GET /" |openssl s_client -connect "$1:443" 2> /dev/null |openssl x509 -noout -dates)
# For STARTTLS over e.g. smtp, replace the offending field by:
# openssl s_client -connect "$1:25" -starttls smtp
if [ -z "$dates" ]; then
    echo "[!] Invalid IP, not SSL or no cert found"
    exit 2
fi
not_after=$(echo $dates|cut -d '=' -f 3)
now_epoch=$(date +%s)
not_after_epoch=$(date +%s -d "$not_after")
if [ $now_epoch -gt $not_after_epoch ]; then
    echo "[!] Certificate for $1 has expired: $not_after"
    exit 1
else
    echo "[-] Certificate for $1 has not expired yet: $not_after"
fi
