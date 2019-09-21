#!/bin/bash
set -e

# This script has been tested on a fresh Ubuntu 18.04 (amd64) install

#Color to the people
CYAN='\x1B[0;36m'
GREEN='\x1B[0;32m'
NC='\x1B[0m'

#Check if go is already installed

if ! [ -x "$(command -v go)" ];

    then
      #Making sure the distro is up-to-date
      sudo apt-get update -y
      sudo apt-get upgrade -y
      sudo apt install -y git
      sudo apt install -y curl
      sudo apt install -y screen
      #Get the latest version of GO for amd64 & installing it
      echo -e "${RED}GO is not installed on your system${NC}"  
      GO_LATEST=$(curl -sS https://golang.org/VERSION?m=text)
      echo -e
      echo -e "${GREEN}The latest version Go is:${CYAN}$GO_LATEST${NC}"
      echo -e "${GREEN}Installing it now...${NC}"
      echo -e
      wget https://dl.google.com/go/$GO_LATEST.linux-amd64.tar.gz
      sudo tar -C /usr/local -xzf $GO_LATEST.linux-amd64.tar.gz
      rm $GO_LATEST.linux-amd64.tar.gz
  
    else
      VER=$(go version)
      echo -e "${GREEN}GO is already installed: ${CYAN}$VER${NC}${GREEN}...skipping install${NC}"
      
  fi

#Let's handle the paths
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
mkdir -p "$HOME/go"
echo "export GOPATH=$HOME/go" >> ~/.profile
source ~/.profile
