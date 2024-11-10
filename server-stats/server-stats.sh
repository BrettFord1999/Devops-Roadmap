#!/bin/bash
#
# Print messages in different colors to the terminal.
#
# This function takes a color name and a message as arguments and outputs
# the message in the specified color using ANSI escape codes.
#
# Globals:
#   None
#
# Arguments:
#   $1 - Color name (green|red|white|yellow)
#   $2 - Message to print
#
# Outputs:
#   Writes colored message to stdout
#
# Example:
#   print_color "green" "Success message"
#   print_color "red" "Error message"
#
function print_color() {
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
#########################
# Evaluates a numeric value and prints a colored status message.
#
# Takes a numeric value and a label (e.g., "CPU", "Memory") and outputs
# a colored status message based on thresholds:
#   > 90: Red (Critical)
#   > 70: Yellow (Warning)
#   else: Green (Normal)
#
# Globals:
#   None
#
# Arguments:
#   $1 - Numeric value to evaluate (can be integer or float)
#   $2 - Label for the resource being evaluated (e.g., "CPU", "Memory")
#
# Outputs:
#   Writes colored status message to stdout using print_color function
#
# Example:
#   evaluate_print_color "85.5" "CPU"
#   evaluate_print_color "45.2" "Memory"
#
function evaluate_print_color() {
    if (( $(echo "$1 > 90" | bc -l) )); then
        print_color red "$2 Usage: Critical"
    elif (( $(echo "$1 > 70" | bc -l) )); then
        print_color yellow "$2 Usage: Warning"
    else
        print_color green "$2 Usage: Normal"
    fi
}

echo -e "\n"
# CPU Usage
user_cpu=$(top -bn1 | grep "Cpu(s)" | awk -F ',' '{print $1}'| sed 's/%Cpu(s)://g' | tr -dc '0-9.')
system_cpu=$(top -bn1 | grep "Cpu(s)" | awk -F ',' '{print $2}' | tr -dc '0-9.')
total_cpu=$(echo "$user_cpu + $system_cpu" | bc)

evaluate_print_color $total_cpu "CPU"

echo -e "CPU Usage: User $user_cpu System $system_cpu Total $total_cpu \n"

# Memory Usage
total_memory=$(free -m | grep "Mem:" | awk '{ print $2}')
used_memory=$(free -m | grep "Mem:" | awk '{ print $3}')

#Calculate percentage of used memory
used_memory_percentage=$(echo "$used_memory / $total_memory * 100" | bc)

evaluate_print_color $used_memory_percentage "Memory"
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

