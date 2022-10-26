#!/bin/bash

echo "Hello! This script will help you with server's basic configuration"
read -p "Press any key to continue..." procStart

if [[ $USER != "root" ]]; then
    echo "You need superpowers to execute this script! :O"
else  
    echo "I can see a great power inside you..."

    # Getting the Raspi ready
    apt update -y
    apt upgrade -y
    apt autoremove -y

    # Installing docker and docker-compose to be able to manage images and containers
    apt install docker
    apt install docker-compose

    # Creating folders to be able to assign persistent volumes to the docker images
    mkdir /home/serverAdmin
    mkdir /home/serverAdmin/mySqlLocalServerData # mysql volume
    git clone https://github.com/CosmosKiller/customPanel.git webApp # nginx folder
fi