#!/bin/bash

source ./common.sh
app_name=rabbitmq

check_root
app_code_setup

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOGS_FILE
VALIDATE $? "Added rabbitmq repo"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "created user and given permission"

systemd_setup

print_total_time