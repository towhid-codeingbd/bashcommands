#!/bin/bash

# Install CSF
cd /usr/src
rm -fv csf.tgz
wget https://download.configserver.com/csf.tgz
tar -xzf csf.tgz
cd csf
sh install.sh

# Disable all email alerts
CONFIG="/etc/csf/csf.conf"

declare -A settings=(
  ["LF_EMAIL_ALERT"]="0"
  ["LF_PERMBLOCK_ALERT"]="0"
  ["LF_NETBLOCK_ALERT"]="0"
  ["LF_DISTFTP_ALERT"]="0"
  ["LF_DISTSMTP_ALERT"]="0"
  ["LF_SCRIPT_ALERT"]="0"
  ["LF_SU_EMAIL_ALERT"]="0"
  ["LF_SSH_EMAIL_ALERT"]="0"
  ["LF_CONSOLE_EMAIL_ALERT"]="0"
  ["LF_CPANEL_ALERT"]="0"
  ["LF_QUEUE_ALERT"]="0"
  ["LF_MODSECEMAIL_ALERT"]="0"
  ["LF_PF_EMAIL_ALERT"]="0"
  ["LF_INVALID_EMAIL_ALERT"]="0"
  ["LF_DIRWATCH_DISABLE"]="1"
  ["LF_ALERT_TO"]=""
)

for key in "${!settings[@]}"; do
  sed -i "s/^$key.*/$key = \"${settings[$key]}\"/" "$CONFIG"
done

# Restart CSF
csf -r

echo "CSF installed and all email alerts disabled."
