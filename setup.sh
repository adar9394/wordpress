#!/bin/bash

name="ariedelwp"
user="ariedel"
pass="#ENTERPASSWORDHERE"
dns="ariedelwp-db.ctgsackgk6na.us-east-1.rds.amazonaws.com"

aws rds create-db-instance --db-instance-identifier ariedel-wp --allocated-storage 20 --db-instance-class db.t2.micro --engine mysql --master-username $user --master-user-password $pass --vpc-security-group-ids sg-922e43ee --db-name $name --no-publicly-accessible

sleep 6m
aws ec2 run-instances --image-id ami-6edd3078 --count 1 --instance-type t2.micro --key-name ariedel2 --security-groups "allow ssh and http" --user-data file://startup.sh

#sleep 2400