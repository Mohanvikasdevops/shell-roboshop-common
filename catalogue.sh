#!/bin/bash

source ./common.sh
app_name=catalogue
app_code=nodejs
version=20

check_root
app_setup
app_code_setup
systemd_setup
app_restart

# Loading data into MongoDB
cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>>$LOGS_FILE

INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getDBNames().Indexof("catalogue")')

if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOGS_FILE
    VALIDATE $? "Loading products"
else
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Products already loaded ... $Y SKIPPING $N"
fi

print_total_time
