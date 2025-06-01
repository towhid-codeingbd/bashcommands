#!/bin/bash

FLAG_FILE="/root/cloudlinux_installed.flag"

if [ ! -f "$FLAG_FILE" ]; then
  echo "Step 1: Initial setup and CloudLinux install"

  # Update system and install tools
  yum -y update
  yum -y install wget curl tar firewalld

  # Disable SELinux
  setenforce 0
  sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

  # Start and enable firewall
  systemctl start firewalld
  systemctl enable firewalld

  # Open required ports including SSH 5001
  for port in 2002 2003 2004 2005 21 22 25 53 80 110 143 443 465 993 995 587 3306 5001; do
    firewall-cmd --permanent --add-port=${port}/tcp
  done
  firewall-cmd --reload

  # Change SSH port to 5001
  sed -i 's/#Port 22/Port 5001/' /etc/ssh/sshd_config
  sed -i 's/^Port 22/Port 5001/' /etc/ssh/sshd_config
  systemctl restart sshd

  # Install CloudLinux
  wget https://repo.cloudlinux.com/cloudlinux/sources/cln/cldeploy
  bash cldeploy -k CLP-SBrrX1uoC8qmK1LNnrRjXJml

  # Install kernel and mark flag
  yum -y install kernel
  touch $FLAG_FILE

  echo "Rebooting system to complete CloudLinux installation..."
  sleep 5
  reboot
else
  echo "Step 2: System rebooted, installing Webuzo..."

  # Install Webuzo and selected packages
  wget -N https://files.webuzo.com/install.sh
  chmod 0755 install.sh
  ./install.sh --install=apache2,openlitespeed,nodejs,nodejs14,nodejs16,nodejs17,nodejs18,nodejs19,mariadb109,php82,php81,php80,php74,php73,php72,php71,perl,python2,python3,exim,dovecot,bind,pureftpd,sa,jailshell,webdisk,varnish,django,passenger,csf,ImunifyAV+

  echo "Installation completed."
  rm -f $FLAG_FILE
fi
