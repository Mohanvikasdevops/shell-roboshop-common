#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.109v.store
START_TIME=$(date +%s)


mkdir -p $LOGS_FOLDER

echo "$(date "+%Y-%m-%d %H:%M:%S") | Script Started executing at $(date)" | tee -a $LOGS_FILE

check_root(){
    if [ $USERID -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $R Please run this script wiht root user access $N" | tee -a $LOGS_FILE
        exit 1
    fi
}


VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ... $R FAILURE $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $2 ... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

nodejs_setup(){
    dnf module disable nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Disabling NodeJs default version"

    dnf module enable nodejs:20 -y &>>$LOGS_FILE
    VALIDATE $? "Enabling NodeJs version 20"

    dnf install nodejs -y &>>$LOGS_FILE
    VALIDATE $? "Installing NodeJs"

    npm install &>>$LOGS_FILE
    VALIDATE $? "Installing dependencies"
}

app_setup(){
   #Creating system user 
    id roboshop &>>$LOGS_FILE
    if [ $? -ne 0 ]; then   
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
        VALIDATE $? "Creating system user"
    else
        echo -e "Roboshop user already exist .... $Y SKIPPING $N"
    fi
    #downloading the app
    mkdir -p /app 
    VALIDATE $? "Creatng app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOGS_FILE
    VALIDATE $? "Downloading $app_name Code"

    cd /app
    VALIDATE $? "Moving to app directory" 

    rm -rf /app/* &>>$LOGS_FILE
    VALIDATE $? "Removing existing code"

    unzip /tmp/$app_name.zip &>>$LOGS_FILE
    VALIDATE $? "Unzip $app_name code"

}

systemd_setup (){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$LOGS_FILE
    VALIDATE $? "Created systemctl service"

    systemctl daemon-reload
    systemctl enable $app_name &>>$LOGS_FILE
    systemctl start $app_name
    VALIDATE $? "Starting and enabling $app_name"
}

app_restart(){    
    systemctl restart catalogue
    VALIDATE $? "Restarting catalogue"
}

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Script execute in: $G $TOTAL_TIME seconds $N" | tee -a $LOGS_FILE
}