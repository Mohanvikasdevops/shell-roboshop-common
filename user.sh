#!/bin/bash

source ./common.sh
app_name=user
app_code=nodejs
version=20

check_root
app_code_setup
app_setup
systemd_setup

print_total_time