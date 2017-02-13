#!/bin/bash

user = "ariedel"
pass = "#ENTERPASSWORDHERE"
name = "ariedel-wp"
dns="ariedelwp-db.ctgsackgk6na.us-east-1.rds.amazonaws.com"
sudo -i
apt-get update
apt-get install apache2 php php-mysql and libapache2-mod-php7.0 -y
service apache2 restart
rm /var/www/html/index.html
wget https://wordpress.org/latest.tar.gz -O /tmp/wp.tgz #this saves the link to /tmp/wp.tgz file
tar xfzC /tmp/wp.tgz /var/www/html #this extracts the zip file to a certain dir
mv /var/www/html/wordpress/* /var/www/html/
cd /var/www/html
cd ..
chown www-data:www-data /var/www/html/ -R #We need change ownerships to all files and directories recursively. 
cd /var/www/html
cp wp-config-sample.php wp-config.php


sed -i 's/localhost/ariedel-wp.ctgsackgk6na.us-east-1.rds.amazonaws.com/g' wp-config.php
sed -i 's/database_name_here/ariedel-wp/g' wp-config.php
sed -i 's/username_here/ariedel/g' wp-config.php
sed -i 's/password_here/#ENTERPASSWORDHERE/g' wp-config.php
