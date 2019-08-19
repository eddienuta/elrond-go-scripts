#!/bin/bash

ulimit -n 65535
cd $GOPATH/src/github.com/ElrondNetwork/elrond-go-node
./node
