#!/bin/bash

source ./common.sh
app_name=payment


check_root
app_setup

dnf install python3 gcc python3-devel -y &>>$LOGS_FILE
VALIDATE $? "Installing Python"

cd /app 
pip3 install -r requirements.txt &>>$LOGS_FILE
VALIDATE $? "Installing dependecies"

systemd_setup

print_total_time