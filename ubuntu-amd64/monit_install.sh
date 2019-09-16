#!/bin/bash
set -e

#Color to the people
RED='\x1B[0;31m'
CYAN='\x1B[0;36m'
GREEN='\x1B[0;32m'
NC='\x1B[0m'

read -p "Have you customized your <monitrc> & <testnet> configs ? [y/n] :" answer
 
if [[ $answer = y ]] ; then
                #Install all packages (this includes "sendemail" for better emails in case of node restart)
                echo -e
                echo -e "${GREEN}--> Installing Monit system...{NC}"
                echo -e

                sudo apt install monit sendemail libnet-ssleay-perl libio-socket-ssl-perl -y
                
                #Copying proper config files & restart monit
                echo -e
                echo -e "${GREEN}--> Copying config files for monit & restarting service...{NC}"
                echo -e

                sudo cp /home/ubuntu/elrond-go-scripts/ubuntu-amd64/monit_conf/testnet /etc/monit/conf.d/testnet
                sudo cp /home/ubuntu/elrond-go-scripts/ubuntu-amd64/monit_conf/monitrc /etc/monit/monitrc
                sudo service monit restart
      else
        echo -e
        echo -e "${RED}--> Customize your <monitrc> & <testnet> files with email and scripts and re-run this script...{NC}"
        echo -e

fi