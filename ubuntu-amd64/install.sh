#!/bin/bash

BINARYVER='tags/v1.0.17'
CONFIGVER='tags/testnet-1017'

#Color to the people
RED='\x1B[0;31m'
CYAN='\x1B[0;36m'
GREEN='\x1B[0;32m'
NC='\x1B[0m'

echo -e
echo -e "${GREEN}--> installing Elrond-go{NC}"
echo -e

#setup
bash _golang.sh
cd $GOPATH
mkdir -p $GOPATH/src/github.com/ElrondNetwork
cd $GOPATH/src/github.com/ElrondNetwork

#clone repos
git clone https://github.com/ElrondNetwork/elrond-go
cd elrond-go && git checkout --force $BINARYVER
cd ..
git clone https://github.com/ElrondNetwork/elrond-config
cd elrond-config && git checkout --force $CONFIGVER

#create working folder
mkdir -p $GOPATH/src/github.com/ElrondNetwork/elrond-go-node/config
cp *.* $GOPATH/src/github.com/ElrondNetwork/elrond-go-node/config

#compile elrond-go
cd $GOPATH/src/github.com/ElrondNetwork/elrond-go
GO111MODULE=on go mod vendor
cd cmd/node && go build -i -v -ldflags="-X main.appVersion=$(git describe --tags --long --dirty)"
cp node $GOPATH/src/github.com/ElrondNetwork/elrond-go-node

#choose node name
cd $GOPATH/src/github.com/ElrondNetwork/elrond-go-node/config
read -p "Choose the name of your node (default \"\"): " node_name
if [ ! "$node_name" = "" ]
then
    sed -i 's|NodeDisplayName = ""|NodeDisplayName = "'"$node_name"'"|g' config.toml	
fi

#identity key-gen
cd $GOPATH/src/github.com/ElrondNetwork/elrond-go/cmd/keygenerator
go build
./keygenerator

#copy identity pem files perserving existing ones
cp -n initialBalancesSk.pem $GOPATH/src/github.com/ElrondNetwork/elrond-go-node/config
cp -n initialNodesSk.pem $GOPATH/src/github.com/ElrondNetwork/elrond-go-node/config

#run the node
cd $GOPATH/src/github.com/ElrondNetwork/elrond-go-node
./node


