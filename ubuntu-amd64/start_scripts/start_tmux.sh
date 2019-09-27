#!/bin/bash
#Handle some paths
export GOPATH=$HOME/go

tmux new-session -d -s "testnet"
tmux send -t "testnet" "cd $GOPATH/src/github.com/ElrondNetwork/elrond-go-node" ENTER
tmux send -t "testnet" "./node" ENTER
