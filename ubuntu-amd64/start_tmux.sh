#!/bin/bash

#the node number can be passed to this script as the 1st argument
#if no argument is passed, the standard node work folder is used
if [ "$1" -ge 2 -a "$1" -le 99 ]; then
	suffix="-$(printf "%02d" $1)"
else
	suffix=""
fi

#after using the install.sh script, we want to run the node from the work folder
work_folder="$GOPATH/src/github.com/ElrondNetwork/elrond-go-node$suffix"
tmux_session_name="testnet$suffix"

#check if tmux is already installed and install if necessary
bash _tmux.sh

#run node in background session: testnet
#user can switch to session by using: tmux a
tmux new-session -d -s "$tmux_session_name"
tmux send -t "$tmux_session_name" "ulimit -n 65535" ENTER
tmux send -t "$tmux_session_name" "cd $work_folder" ENTER
tmux send -t "$tmux_session_name" "./node" ENTER
