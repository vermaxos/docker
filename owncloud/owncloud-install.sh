# !/bin/bash
mkdir /owncloud
sudo chmod 755 /owncloud
cp ./docker-compose.yml /owncloud
cd /owncloud

sudo cat << EOF > .env
OWNCLOUD_VERSION=10.10
OWNCLOUD_DOMAIN=localhost:8080
ADMIN_USERNAME=admin
ADMIN_PASSWORD=admin
HTTP_PORT=8080
EOF

SERVICENAME=$(basename $(pwd))
echo "Creating systemd service... /etc/systemd/system/${SERVICENAME}.service"

# Create systemd service file
sudo cat > /etc/systemd/system/$SERVICENAME.service <<EOF
[Unit]
Description=$SERVICENAME
Requires=docker.service
After=docker.service

[Service]
Restart=always
User=root
Group=docker
WorkingDirectory=$(pwd)
ExecStartPre=$(which docker-compose) -f docker-compose.yml down
ExecStart=$(which docker-compose) -f docker-compose.yml up -d
ExecStop=$(which docker-compose) -f docker-compose.yml down
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

echo "Enabling & starting $SERVICENAME"

# Reload systemd units
sudo systemctl daemon-reload
# Autostart systemd service
sudo systemctl enable $SERVICENAME.service
# Start systemd service now
sudo systemctl start $SERVICENAME.service

