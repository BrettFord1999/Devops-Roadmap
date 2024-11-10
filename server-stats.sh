#! /bin/bash

# CPU Usage
user_cpu=$(top -bn1 | grep "Cpu(s)" | awk -F ',' '{print $1}'| sed 's/%Cpu(s)://g')
system_cpu=$(top -bn1 | grep "Cpu(s)" | awk -F ',' '{print $2}')

echo "CPU Usage: $user_cpu $system_cpu"
