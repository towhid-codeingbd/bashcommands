#!/bin/bash

echo "===================="
echo "Step 1: Installing cPanel"
echo "===================="
yum install -y perl curl
cd /home
sh latest

echo "===================="
echo "Step 2: Activating cPanel License"
echo "===================="
/usr/local/cpanel/cpkeyclt

echo "===================="
echo "Step 3: Enabling ionCube Loader for Backend PHP"
echo "===================="
echo "ioncube=1" >> /var/cpanel/cpanel.config
/usr/local/cpanel/whostmgr/bin/whostmgr2 --updatetweaksettings
/usr/local/cpanel/bin/rebuild_phpconf --default

echo "===================="
echo "Step 4: Installing CloudLinux"
echo "===================="
wget https://repo.cloudlinux.com/cloudlinux/sources/cln/cldeploy
sh cldeploy -i

echo "===================="
echo "Step 5: Installing All ALT-PHP Versions"
echo "===================="
dnf group install -y alt-php

echo "===================="
echo "Step 6: Installing All Python Versions (Manual Step Required)"
echo "===================="
echo "❗ Please install Python versions manually or specify versions you'd like to include."

echo "===================="
echo "Step 7: Installing All Node.js Versions (Manual Step Required)"
echo "===================="
echo "❗ Please install Node.js versions manually or specify versions you'd like to include."

echo "===================="
echo "Step 8: Installing LiteSpeed (TRIAL)"
echo "===================="
bash <( curl https://get.litespeed.sh ) TRIAL

echo "===================="
echo "Step 9: Installing Imunify360"
echo "===================="
wget https://repo.imunify360.cloudlinux.com/defence360/i360deploy.sh -O i360deploy.sh
bash i360deploy.sh

echo "===================="
echo "Step 10: Installing Softaculous"
echo "===================="
wget -N https://files.softaculous.com/install.sh
chmod 755 install.sh
./install.sh

echo "===================="
echo "Step 11: Installing JetBackup 5"
echo "===================="
bash <(curl -LSs http://repo.jetlicense.com/static/install)
jetapps --install jetbackup5-cpanel stable

echo "===================="
echo "Step 12: Installing CSF Firewall"
echo "===================="
cd /usr/src
rm -fv csf.tgz
wget https://download.configserver.com/csf.tgz
tar -xzf csf.tgz
cd csf
sh install.sh

echo "===================="
echo "✅ All steps completed successfully!"
echo "===================="
