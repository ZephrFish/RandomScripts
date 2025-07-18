#!/bin/bash
# It will also do a range if you make a second for loop
host=$1

for port in 22 3389 443 80; do timeout 1 bash -c "</dev/tcp/$host/$port" && echo "$port open" || echo "$port closed"; done
