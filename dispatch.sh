#!/bin/bash

source ./common.sh
app_name=dispatch

check_root
app_setup
systemd_setup

dnf install golang -y &>>$LOGS_FILE
VALIDATE $? "Installing golang"
 
cd /app 
go mod init dispatch
go get 
go build &>>$LOGS_FILE
VALIDATE $? "Installing dependecies"

print_total_time