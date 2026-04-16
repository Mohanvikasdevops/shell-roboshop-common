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

rm -rf $app_dir*  &>>$LOGS_FILE
VALIDATE $? "Removing existing code"

curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOGS_FILE
VALIDATE $? "Downloading $app_name Code"

cd $app_dir
VALIDATE $? "Moving to app directory" 

unzip /tmp/$app_name.zip &>>$LOGS_FILE
VALIDATE $? "Unzip $app_name code"

rm -rf /etc/nginx/nginx.conf  &>>$LOGS_FILE
VALIDATE $? "Removing existing code"

cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>>$LOGS_FILE
VALIDATE $? "Copied our nginx conf file"

app_restart
print_total_time