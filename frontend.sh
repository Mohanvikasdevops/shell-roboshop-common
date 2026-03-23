#!/bin/bash

source ./common.sh
app_name=frontend
app_code=nginx
version=1.24

check_root
app_code_setup

systemctl enable nginx &>>$LOGS_FILE
systemctl start nginx
VALIDATE $? "Starting and enabling nginx"

rm -rf /usr/share/nginx/html/*  &>>$LOGS_FILE
VALIDATE $? "Removing existing code"

app_setup

rm -rf /etc/nginx/nginx.conf  &>>$LOGS_FILE
VALIDATE $? "Removing existing code"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>>$LOGS_FILE
VALIDATE $? "Copied our nginx conf file"

app_restart
print_total_time