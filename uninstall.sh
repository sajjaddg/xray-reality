#!/bin/bash

# Stop the Xray service
sudo systemctl stop xray

# Remove the Xray binary
sudo rm /usr/bin/xray

# Remove the Xray configuration file
sudo rm /etc/xray/config.json

# Remove the Xray service file
sudo rm /etc/systemd/system/xray.service

# Reload the systemd daemon
sudo systemctl daemon-reload

# Remove any leftover Xray files or directories
sudo rm -rf /var/log/xray /var/lib/xray
