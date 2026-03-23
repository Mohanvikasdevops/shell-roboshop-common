#!/bin/bash

source ./common.sh
app_name=frontend
app_code=nginx
version=1.24

check_root
app_code_setup
systemd_setup

rm -rf /usr/share/nginx/html/*  &>>$LOGS_FILE
VALIDATE $? "Removing existing code"

app_setup
app_restart
print_total_time