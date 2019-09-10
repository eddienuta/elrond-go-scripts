#!/bin/bash

#the node number can be passed to this script as the 1st argument
#if no argument is passed, the standard node work folder is used
node_number=$1
rest_api_port=8080

if [ "$node_number" -ge 2 -a "$node_number" -le 99 ]; then
	suffix="-$(printf "%02d" $node_number)"
	rest_api_port=$((rest_api_port+node_number-1))
else
	suffix=""
fi

#after using the install.sh script, we want to run the node from the work folder
work_folder="$GOPATH/src/github.com/ElrondNetwork/elrond-go-node$suffix"

#check if tmux is already installed and install if necessary
bash _tmux.sh

#run node in background session: tmux_session_name
#user can switch to this session by using: tmux a
tmux_session_name="testnet$suffix"
tmux new-session -d -s "$tmux_session_name"
tmux send -t "$tmux_session_name" "ulimit -n 65535" ENTER
tmux send -t "$tmux_session_name" "cd $work_folder" ENTER
tmux send -t "$tmux_session_name" "./node --rest-api-port $rest_api_port" ENTER
