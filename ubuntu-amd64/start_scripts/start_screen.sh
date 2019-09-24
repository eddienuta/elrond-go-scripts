#!/bin/bash

cd $GOPATH/src/github.com/ElrondNetwork/elrond-go-node
screen -A -m -d -S testnet ./node 
