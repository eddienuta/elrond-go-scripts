#!/bin/bash

BINARYVER='tags/v1.0.17'
CONFIGVER='tags/testnet-1017'

#Color to the people
RED='\x1B[0;31m'
CYAN='\x1B[0;36m'
GREEN='\x1B[0;32m'
NC='\x1B[0m'

#refetch and rebuild elrond-go
cd $HOME/go/src/github.com/ElrondNetwork/elrond-go
git fetch
git checkout --force $BINARYVER
git pull
cd cmd/node
GO111MODULE=on go mod vendor
go build -i -v -ldflags="-X main.appVersion=$(git describe --tags --long --dirty)"
cp node $GOPATH/src/github.com/ElrondNetwork/elrond-go-node

#refetch and rebuild elrond-config
cd $HOME/go/src/github.com/ElrondNetwork/elrond-config
git fetch
git checkout --force $CONFIGVER
git pull
cp *.* $GOPATH/src/github.com/ElrondNetwork/elrond-go-node/config

#choose node name
cd $GOPATH/src/github.com/ElrondNetwork/elrond-go-node/config
read -p "Choose the name of your node (default \"\"): " node_name
if [ ! "$node_name" = "" ]
then
    sed -i 's|NodeDisplayName = ""|NodeDisplayName = "'"$node_name"'"|g' config.toml	
fi

#cleanup db
cd $GOPATH/src/github.com/ElrondNetwork/elrond-go-node
read -p "Remove db? (default yes): " rem_db
if [ "$rem_db" != "no" ]
then
  sudo rm -rd db
fi
sudo rm -rd logs
sudo rm -rd stats


#ask about screen launch
on_screen='no'
read -p "Launch on virtual screen? (default no): " on_screen
if [ "$on_screen" = "no" ] | [ "$on_screen" = "n" ] | [ "$on_screen" = "" ]
then
  ./node
else
  screen -A -m -d -S testnet ./node
fi

#run the node


