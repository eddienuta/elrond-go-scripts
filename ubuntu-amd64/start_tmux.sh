#!/bin/bash

#the node number can be passed to this script as the 1st argument
#if no argument is passed, the standard node work folder is used

if [ $# -eq 0 ]; then
	node_number=1
else
	node_number=$1
fi
rest_api_port=8080

if [ "$node_number" -ge 2 -a "$node_number" -le 99 ]; then
	suffix="-$(printf "%02d" $node_number)"
	rest_api_port=$((rest_api_port+node_number-1))
else
	suffix=""
fi

#after using the install.sh script, we want to run the node from the work folder
work_folder="$GOPATH/src/github.com/ElrondNetwork/elrond-go-node$suffix"

#run node in background session: tmux_session_name
#user can switch to this session by using: tmux a -t $tmux_session_name
#for a single node, this will be: tmux a -t testnet
#to detach from that session again: <Ctrl+b>, followed by <d>
tmux_session_name="testnet$suffix"
tmux new-session -d -s "$tmux_session_name"
tmux send -t "$tmux_session_name" "cd $work_folder" ENTER
tmux send -t "$tmux_session_name" "./node --rest-api-port $rest_api_port" ENTER
