#!/bin/bash

##############################################################
# Script to analyze Nginx access logs
##############################################################

<<COMMENT
Requirements:
Top 5 IP addresses with the most requests
Top 5 most requested paths
Top 5 response status codes
Top 5 user agents
COMMENT

# Check if log file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/logfile"
    exit 1
fi

# Check if head is provided
head=$2
if [ -z "$head" ]; then
    head=5
fi

# Define colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

##############################################################
# print_top function    
# pass in logfile, head, and type of analysis
# type of analysis: ip, paths, status codes, user agents
# print top N results with colors
##############################################################   

function print_top() {
    case $3 in
        "ip")  
            field=1
            ;;
        "paths")
            field=7
            ;;
        "status codes")
            field=9
            ;;
        "user agents")
            field=12
            ;;
    esac    
    echo -e "\n${GREEN}Top $2 $3${NC}\n"

    # Process log file:
    # 1. Extract specified field
    # 2. Sort entries
    # 3. Count unique occurrences
    # 4. Sort numerically in reverse order
    # 5. Take top N results
    # 6. Format output with colors
    awk "{print \$$field}" "$1" | \
        sort | \
        uniq -c | \
        sort -nr | \
        head -n $2 | \
        awk -v green="$GREEN" -v blue="$BLUE" -v nc="$NC" \
            '{printf "%s%6s%s %s%s%s\n", green, $1, nc, blue, $2, nc}'

    # Print separator line
    echo -e "${GREEN}----------------------------------------\n"
}

print_top "$1" "$2" "ip"
print_top "$1" "$2" "paths"
print_top "$1" "$2" "status codes"
print_top "$1" "$2" "user agents"