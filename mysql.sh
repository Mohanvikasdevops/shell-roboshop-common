#!/bin/bash

source ./common.sh
app_name=mysql

check_root
app_setup
systemd_setup

print_total_time

dnf install mysql-server -y &>>$LOGS_FILE
VALIDATE $? "Installed MySQL server"

#get the password from user
mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Setup root password"

print_total_time
