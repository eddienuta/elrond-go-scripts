# elrond-go-scripts #
Scripts for easy install and update of an elrond-go node

## ubuntu-amd64 ##
Scripts built for & testet on Ubuntu 18.04 LTS Server (should work on other related distros). <br>
Remeber to do:
```
git fetch
git --force pull
```
after the announcement of a new testnet.

### Scripts breakdown: ###

***ubuntu-amd64***
* golang.sh        ----> Check if GoLang is installed. If not it installs the latest version (called in install.sh)
* _prerequisite.sh ----> Updates your disto and installs some needed packages
* install.sh       ----> Main install script - clones repos, builds node, generates pems & gives you options to start node
* monitrc          ----> Deployed by the monit_install.sh script. You need to customize this before running the script !!!
* testnet          ----> Deployed by the monit_install.sh script. You need to customize this before running the script !!!
* monit_install.sh ----> Installs the monit system to keep node running. This should be installed after node is running. (optional)
* start.sh         ----> This runs the node in the foreground in the current terminal window/console
* start_screen.sh  ----> Creates a "testnet" screen session and starts the node binary inside it
* start_tmux.sh    ----> Similar to the screen script but using the tmux application instead
* start_tmux.sh    ----> Tmux script for running multiple nodes at once (community addition to scripts - by ahakla)     
* update.sh        ----> Script used to update node binary if needed


## windows-amd64 ##
Scripts built for & tested on Windows 10 Pro 1903 64 bit

### Scripts breakdown: ###

***windows-amd64***
* buildnode.bat    ----> This script builds the node binary, generates pems and put all files in place (run prereq.bat first)
* prereq.bat       ----> RUN THIS WITH ADMINISTRATOR RIGHTS !!! This will install git & GoLang if you don't have them. RUN THIS FIRST !!!
* start.bat        ----> This will start your node inside a cmd window
