#!/bin/bash

BINARYVER='tags/v1.0.17'
CONFIGVER='tags/testnet-1017'


#Color to the people
RED='\x1B[0;31m'
CYAN='\x1B[0;36m'
GREEN='\x1B[0;32m'
NC='\x1B[0m'

echo -e
echo -e "${GREEN}--> Installing Elrond-Go Node...${NC}"
echo -e

#Prerequisites & go installer
echo -e
echo -e "${GREEN}--> Running machine update & installing latest GOLang...${NC}"
echo -e
bash _prerequisite.sh
bash _golang.sh

#Handle some paths
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
cd $GOPATH

#If repos are present and you run install again this will clean up for you :D
if [ -d "$GOPATH/src/github.com/ElrondNetwork/elrond-go" ]; then echo -e "${RED}--> Repos present. Please run update.sh script...${NC}"; echo -e; exit; fi

mkdir -p $GOPATH/src/github.com/ElrondNetwork
cd $GOPATH/src/github.com/ElrondNetwork

echo -e
echo -e "${GREEN}--> Cloning the ${CYAN}elrond-go${GREEN} & ${CYAN}elrond-config${GREEN} repos...${NC}"
echo -e

#Clone the elrong-go & elrong-config repos
git clone https://github.com/ElrondNetwork/elrond-go
cd elrond-go && git checkout --force $BINARYVER
cd ..
git clone https://github.com/ElrondNetwork/elrond-config
cd elrond-config && git checkout --force $CONFIGVER

#Create the working folder & getting current testnet configs
mkdir -p $GOPATH/src/github.com/ElrondNetwork/elrond-go-node/config
cp *.* $GOPATH/src/github.com/ElrondNetwork/elrond-go-node/config

#Building the node from the elrond-go repo
cd $GOPATH/src/github.com/ElrondNetwork/elrond-go
GO111MODULE=on go mod vendor
cd cmd/node && go build -i -v -ldflags="-X main.appVersion=$(git describe --tags --long --dirty)"
cp node $GOPATH/src/github.com/ElrondNetwork/elrond-go-node

#Choose a custom node name... or leave it at default
echo -e
echo -e "${GREEN}--> Build ready. Time to choose a node name...${NC}"
echo -e
cd $GOPATH/src/github.com/ElrondNetwork/elrond-go-node/config
CURRENT=$(sed -e 's#.*-\(\)#\1#' <<< "$CONFIGVER")
read -p "Choose a custom name (default community-validator-$CURRENT): " NODE_NAME
if [ "$node_name" = "" ]
then
    NODE_NAME="community-validator-$CURRENT"
fi
sed -i 's/NodeDisplayName = ""/NodeDisplayName = "'$NODE_NAME'"/' $HOME/go/src/github.com/ElrondNetwork/elrond-go-node/config/config.toml

#Build Key Generator and create unique node keys
echo -e
echo -e "${GREEN}--> Building the Key Generator & creating unique node pems...${NC}"
echo -e
cd $GOPATH/src/github.com/ElrondNetwork/elrond-go/cmd/keygenerator
go build
./keygenerator

#copy identity pem files perserving existing ones
cp -n initialBalancesSk.pem $GOPATH/src/github.com/ElrondNetwork/elrond-go-node/config
cp -n initialNodesSk.pem $GOPATH/src/github.com/ElrondNetwork/elrond-go-node/config


echo -e
echo -e "${GREEN}Options for starting your Elrond Node:${NC}"
echo -e "${CYAN}front${GREEN} - Will start your node in the foreground${NC}"
echo -e "${CYAN}screen${GREEN} - Will start your node in the backround using the screen app${NC}"
echo -e "${CYAN}tmux${GREEN} - Will start your node in the backround using the tmux app${NC}"
echo -e "${CYAN}ENTER${GREEN} - Will exit to the command line without starting your node (in case you need to add previously generated pems)${NC}"
echo -e
echo -e

read -p "How do you want to start your node (front|screen|tmux) : " START

case $START in
     front)
        cd $HOME/elrond-go-scripts/ubuntu-amd64/start_scripts/ && ./start.sh
        ;;
     screen)
        cd $HOME/elrond-go-scripts/ubuntu-amd64/start_scripts/ && ./start_screen.sh
        ;;
     
     tmux)
        cd $HOME/elrond-go-scripts/ubuntu-amd64/start_scripts/ && ./start_tmux.sh
        ;;
     
     *)
        echo "Ok ! Have it your way then..."
        ;;
esac

