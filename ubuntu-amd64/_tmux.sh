#!/bin/bash
set -e

# This script has been tested on a fresh Ubuntu 18.04 (amd64) install

#Color to the people
CYAN='\x1B[0;36m'
GREEN='\x1B[0;32m'
NC='\x1B[0m'

#Check if tmux is already installed

if ! [ -x "$(command -v tmux)" ];

    then
      #Making sure the distro is up-to-date
      sudo apt-get update -y
      sudo apt-get upgrade -y
      #Get the latest version of TMUX for amd64 & installing it
      echo -e "${RED}TMUX is not installed on your system${NC}"
      sudo apt-get install -y tmux
    else
      VER=$(tmux -V)
      echo -e "${GREEN}TMUX is already installed: ${CYAN}$VER${NC}${GREEN}...skipping install${NC}"

fi
