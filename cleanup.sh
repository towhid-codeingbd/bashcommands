#!/bin/bash

echo "Starting cleanup of large log files..."

# Truncate large log files
sudo truncate -s 0 /var/log/firewall
sudo truncate -s 0 /var/log/messages
sudo truncate -s 0 /var/log/secure
sudo truncate -s 0 /var/log/cron

# Remove old rotated/compressed logs
sudo rm -f /var/log/*.gz /var/log/*.1 /var/log/*.old

# Restart rsyslog service to apply changes
sudo systemctl restart rsyslog

echo "Cleanup completed. Please check disk space with 'df -h'."
