#! /bin/bash
#########################
# Function to print color
#########################
function print_color(){
    case $1 in
    green)
        color=32
        ;;
    red)
        color=31
        ;;
    white)
        color=37
        ;;
    yellow)
        color=33
        ;;
    esac
    message=$2
    echo -e "\e[${color}m${message}\e[0m"
}

function evaluate_print_color(){
    if (( $(echo "$1 > 90" | bc -l) )); then
        print_color red $1
    elif (( $(echo "$1 > 70" | bc -l) )); then
        print_color yellow $1
    else
        print_color green $1
    fi
}

echo -e "\n"
# CPU Usage
user_cpu=$(top -bn1 | grep "Cpu(s)" | awk -F ',' '{print $1}'| sed 's/%Cpu(s)://g' | tr -dc '0-9.')
system_cpu=$(top -bn1 | grep "Cpu(s)" | awk -F ',' '{print $2}' | tr -dc '0-9.')
total_cpu=$(echo "$user_cpu + $system_cpu" | bc)

if (( $(echo "$total_cpu > 90" | bc -l) )); then
    print_color red "CPU Usage: Critical" 
else
    print_color green "CPU Usage: Normal"
fi
echo -e "CPU Usage: User $user_cpu System $system_cpu Total $total_cpu \n"

# Memory Usage
total_memory=$(free -m | grep "Mem:" | awk '{ print $2}')
used_memory=$(free -m | grep "Mem:" | awk '{ print $3}')

#Calculate percentage of used memory
used_memory_percentage=$(echo "$used_memory / $total_memory * 100" | bc)

if (( $(echo "$used_memory_percentage > 80" | bc -l) )); then
    print_color red "Memory Usage: Critical"
else
    print_color green "Memory Usage: Normal"
fi
echo "Memory Usage: Used $used_memory_percentage%"
echo -e "Memory Info: Total $total_memory Used $used_memory \n"


# Disk Usage
total_disk_space=$( df -h / | grep / | awk '{print $2}')
used_disk_space=$(df -h / | grep / | awk '{print $3}')
used_disk_space_percentage=$(echo "$used_disk_space / $total_disk_space * 100" | bc)

if (( $(echo "$used_disk_space_percentage > 90" | bc -l) )); then
    print_color red "Disk Usage: Critical"
else
    print_color green "Disk Usage: Normal"
fi

echo -e "Disk Usage: Total $total_disk_space Used $used_disk_space Used Percentage $used_disk_space_percentage \n"

#top 5 processes by CPU
print_color green "Top 5 Processes by CPU"
top -b -o %CPU -n 1 | tail -n +6 | head -n 5

#top 5 processes by Memory
print_color green "Top 5 Processes by Memory"
top -b -o %MEM -n 1 | tail -n +6 | head -n 5
