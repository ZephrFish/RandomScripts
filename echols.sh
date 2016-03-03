#!/bin/bash
# Replacement for ls with echo 
# Useful for rbash and restriced 
#
for file in <absolutepath>; do echo ${file##*/}; done
