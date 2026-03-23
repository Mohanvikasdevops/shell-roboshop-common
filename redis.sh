#!/bin/bash

source ./common.sh
app_name=redis
app_code=redis
version=7

check_root
app_code_setup
sed_setup
systemd_setup

print_total_time