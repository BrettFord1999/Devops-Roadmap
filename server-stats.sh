#! /bin/bash

# CPU Usage
user_cpu=$(top -bn1 | grep "Cpu(s)" | awk -F ',' '{print $1}'| sed 's/%Cpu(s)://g' | tr -dc '0-9.')
system_cpu=$(top -bn1 | grep "Cpu(s)" | awk -F ',' '{print $2}' | tr -dc '0-9.')
total_cpu=$(echo "$user_cpu + $system_cpu" | bc)

echo "CPU Usage: User $user_cpu System $system_cpu Total $total_cpu"

# Memory Usage
total_memory=$(free -m | grep "Mem:" | awk '{ print $2}')
used_memory=$(free -m | grep "Mem:" | awk '{ print $3}')
echo "Memory Usage: Total $total_memory Used $used_memory"
#Calculate percentage of used memory
used_memory_percentage=$(echo "scale=2; $used_memory / $total_memory * 100" | bc)
echo "Memory Usage: Used $used_memory_percentage%"
