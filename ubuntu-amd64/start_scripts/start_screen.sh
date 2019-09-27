#!/bin/bash
#Handle some paths
export GOPATH=$HOME/go

cd $GOPATH/src/github.com/ElrondNetwork/elrond-go-node
screen -A -m -d -S testnet ./node 
