#!/bin/bash

echo -n 'Do you want to delete volumes? (y or n, default is n): '
read choice

cd /owncloud

SERVICENAME=$(basename $(pwd))

sudo systemctl stop $SERVICENAME

if [ "$choice" == "y" ]; then
    sudo docker volume rm $(docker volume ls -q)
fi

sudo rm /etc/systemd/system/$SERVICENAME.service
sudo systemctl daemon-reload

sudo rm -r /owncloud

echo 'Uninstallation completed!'
