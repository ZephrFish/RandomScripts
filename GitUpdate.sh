#!/bin/bash
# Update all git directories below current directory or specified directory
# Skips directories that contain a file called .ignore
#  ZephrFish 1.0

HIGHLIGHT="\e[01;34m"
NORMAL='\e[00m'

function update {
  local d="$1"
  if [ -d "$d" ]; then
    if [ -e "$d/.ignore" ]; then
      echo -e "\n${HIGHLIGHT}Ignoring $d${NORMAL}"
    else
      cd $d > /dev/null
      if [ -d ".git" ]; then
        echo -e "\n${HIGHLIGHT}Updating `pwd`$NORMAL"
        git pull
      else
        scan *
      fi
      cd .. > /dev/null
    fi
  fi
  #echo "Exiting update: pwd=`pwd`"
}

function scan {
  #echo "`pwd`"
  for x in $*; do
    update "$x"
  done
}

if [ "$1" != "" ]; then cd $1 > /dev/null; fi
echo -e "${HIGHLIGHT}Scanning ${PWD}${NORMAL}"
scan *
