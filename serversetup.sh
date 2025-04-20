#!/bin/bash

echo "===================="
echo "Step 1: Installing cPanel"
echo "===================="
yum update -y
yum upgrade -y
yum install -y perl curl
cd /home
curl -o latest -L https://securedownloads.cpanel.net/latest
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
echo "Step 4: Installing LiteSpeed (TRIAL)"
echo "===================="
bash <( curl https://get.litespeed.sh ) TRIAL

echo "===================="
echo "Step 5: Installing Imunify360"
echo "===================="
wget https://repo.imunify360.cloudlinux.com/defence360/i360deploy.sh -O i360deploy.sh
bash i360deploy.sh

echo "===================="
echo "Step 6: Installing Softaculous"
echo "===================="
wget -N https://files.softaculous.com/install.sh
chmod 755 install.sh
./install.sh

echo "===================="
echo "Step 7: Installing JetBackup 5"
echo "===================="
bash <(curl -LSs http://repo.jetlicense.com/static/install)
jetapps --install jetbackup5-cpanel stable

echo "===================="
echo "Step 8: Installing CSF Firewall"
echo "===================="
cd /usr/src
rm -fv csf.tgz
wget https://download.configserver.com/csf.tgz
tar -xzf csf.tgz
cd csf
sh install.sh

echo "===================="
echo "Step 9: Installing CloudLinux"
echo "===================="
wget https://repo.cloudlinux.com/cloudlinux/sources/cln/cldeploy
sh cldeploy -i

echo "===================="
echo "Step 10: Installing All ALT-PHP Versions"
echo "===================="
dnf groupinstall -y alt-php

echo "===================="
echo "Step 11: Installing Common ALT-PHP Extensions"
echo "===================="
for ver in 5.1 5.2 5.3 5.4 5.5 5.6 7.0 7.1 7.2 7.3 7.4 8.0 8.1 8.2; do
  dnf install -y ea-php${ver//./}-php-cli ea-php${ver//./}-php-common ea-php${ver//./}-php-mbstring ea-php${ver//./}-php-mysqlnd ea-php${ver//./}-php-pdo ea-php${ver//./}-php-gd ea-php${ver//./}-php-opcache ea-php${ver//./}-php-curl ea-php${ver//./}-php-xml
done

echo "===================="
echo "Step 12: Installing All ALT-Python Versions"
echo "===================="
dnf groupinstall -y alt-python

echo "===================="
echo "Step 13: Installing Node.js via CLN"
echo "===================="
dnf install -y lvemanager
dnf module enable -y nodejs:18
dnf install -y nodejs

echo "===================="
echo "Step 14: Enabling Ruby/Python Selector in LiteSpeed"
echo "===================="
/usr/local/lsws/admin/misc/enable_ruby_python_selector.sh

echo "===================="
echo "Step 15: Installing PostgreSQL for cPanel"
echo "===================="
/usr/local/cpanel/scripts/installpostgres

echo "===================="
echo "✅ All steps completed successfully!"
echo "===================="
