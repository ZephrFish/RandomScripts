#!/bin/bash
# Random IP Printer
# ZephrFish
# v1.0
# Check for Arguments
if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo -e "\nUsage:\n$0 <file_with_IPs> \n"
    exit 1
fi

# Does File name exist?
if [ ! -f $1 ]; then
    echo "File not found!"
    exit 1
fi

# Define Variables
total="$(cat $1 | uniq | wc -l )" # Total unique IPs in file
number=$RANDOM # Random Number Creation
d=false # change to true to turn on debugging

# Set number to be less than/equal to total
let number="number %= $total"

# Percentage
t=100 # 100 is base number
p=$(echo "$number/$total" | bc -l) # Work out percentage
ap=$(echo $t $p | awk '{printf "%4.3f\n",$1*$2}') # Actual number as a float

# Find Amount of Lines from File
numberlines=$(echo "$total/100" | bc) # Find out number of lines in file as percent per one line
floatlines=$(echo $numberlines $ap | awk '{printf "%4.3f\n",$1*$2}')
intlines=${floatlines%.*} # Round float back up to a whole number
# Debugging Function
debug(){
echo "Total Unique Number of IPs in file is:"
echo ${total}
echo "Random Number is:"
echo ${number}
#echo "The percent in bc format:"
#echo ${p}
echo "The Actual percentage in numerical form:"
echo ${ap}
echo "This Equates to $intlines of IPs"
}

# Check if Debug flag is enabled
if [ "$d" = true ] ; then
echo "[+] Debug Mode [Enabled] Disabled"
        debug
fi

echo "$intlines" | sed -n "$intlines"p  $1

