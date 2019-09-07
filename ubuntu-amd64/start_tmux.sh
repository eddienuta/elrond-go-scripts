#!/bin/bash

#check if tmux is already installed and install if necessary
bash _tmux.sh

#run node in background session: testnet
#user can switch to session by using: tmux a
tmux new-session -d -s testnet
tmux send -t testnet "ulimit -n 65535" ENTER
tmux send -t testnet "cd $GOPATH/src/github.com/ElrondNetwork/elrond-go/cmd/node" ENTER
tmux send -t testnet "./node" ENTER
