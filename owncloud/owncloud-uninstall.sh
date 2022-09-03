#!/bin/bash

echo -n 'Do you want to delete volumes? (y or n, default is n): '
read choice

cd /owncloud

SERVICENAME=$(basename $(pwd))

systemctl stop $SERVICENAME

if [ "$choice" == "y" ]; then
    docker volume rm $(docker volume ls -q)
fi

rm /etc/systemd/system/$SERVICENAME.service
systemctl daemon-reload

rm -r /owncloud

echo 'Uninstallation completed!'
