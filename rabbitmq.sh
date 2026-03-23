#!/bin/bash

source ./common.sh
app_name=rabbitmq

check_root


cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$LOGS_FILE
VALIDATE $? "Added rabbitmq repo"

dnf install rabbitmq-server -y
VALIDATE $? "Installing Rabbitmq server"

systemd_setup

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "created user and given permission"



print_total_time