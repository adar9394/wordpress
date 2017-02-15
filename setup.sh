#!/bin/bash
DBNAME=''
DBINSTANCE=''
DBUSER=''
DBPASS=''
n=0
aws rds create-db-instance --db-instance-identifier $DBINSTANCE --db-instance-class db.t2.micro --db-name $DBNAME --engine mysql --master-username $DBUSER --master-user-password $DBPASS --allocated-storage 5  --vpc-security-group-ids sg-922e43ee --no-publicly-accessible
echo "Launching db...please wait...."
while true
do
  DBHOST=$(aws rds describe-db-instances | jq .DBInstances[].Endpoint.Address | tr -d '""' | grep $DBINSTANCE)
  if [ $? -eq 0 ]; then
	break;
  else
  	((n=$n+3))
	echo "retrying after 3 sec..."
	echo "it has been $n seconds"
	sleep 3
  fi
done

cat <<EOF > startup.sh
#!/bin/bash


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
cd /var/www/html/
sed -i 's/localhost/$DBHOST/g' wp-config.php 
sed -i 's/username_here/$DBUSER/g' wp-config.php 
sed -i 's/password_here/$DBPASS/g' wp-config.php 
sed -i 's/database_name_here/$DBNAME/g' wp-config.php 
EOF
aws ec2 run-instances --image-id ami-6edd3078 --count 1 --instance-type t2.micro --key-name ariedel2 --security-groups "allow ssh and http" --user-data file://startup.sh