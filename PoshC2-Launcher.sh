#!/bin/bash
# Posh Launcher
# req byobu && PoshC2
# sudo apt install byobu
# curl -sSL https://raw.githubusercontent.com/nettitude/PoshC2/master/Install.sh | bash
# First we create a new sesson, this can be called anything
byobu new-session -d -s "PoshC2"

# Next create a split window vertically into two halves
byobu split-window -v

# Setup posh-server on top halve
byobu send-keys -t 0 "posh-server" Enter

# Setup posh implant handler in bottom window
byobu send-keys -t 1 "posh -u $USER" Enter

# Select newly created window
byobu attach-session -t "PoshC2"

