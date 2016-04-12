#!/bin/bash
echo "Screenshot Tool"
echo "Written by ZephrFish"
mkdir $1_outputs
for i in $(cat $1); 
    do 
      xvfb-run cutycapt --url=https://$i --out=$1_outputs/https_$i.png --out-format=png; 
      xvfb-run cutycapt --url=http://$i --out=$1_outputs/http_$i.png --out-format=png; 
done
tar czvf $1_screens.tar.gz $1_outputs/*
rm -rf $1_outputs
echo "[!] Finished..."
