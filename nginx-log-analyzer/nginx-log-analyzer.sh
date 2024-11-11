#!/bin/bash

<<COMMENT
Requirements:
Top 5 IP addresses with the most requests
Top 5 most requested paths
Top 5 response status codes
Top 5 user agents
COMMENT

# Check if log file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/nginx.log"
    exit 1
fi

# Define colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "\n${GREEN}Top 5 IP addresses with the most requests${NC}\n"
# Get IP addresses and count them, with colored output
awk '{print $1}' "$1" | sort | uniq -c | sort -nr | head -n 5 | awk -v green="$GREEN" -v blue="$BLUE" -v nc="$NC" '{printf "%s%6s%s %s%s%s\n", green, $1, nc, blue, $2, nc}'
echo -e "${GREEN}----------------------------------------${NC}"

echo -e "\n${GREEN}Top 5 most requested paths:${NC}"
# Get most requested paths and count them
awk '{print $7}' "$1" | sort | uniq -c | sort -nr | head -n 5 | awk -v green="$GREEN" -v blue="$BLUE" -v nc="$NC" '{printf "%s%6s%s %s%s%s\n", green, $1, nc, blue, $2, nc}'
echo -e "${GREEN}----------------------------------------\n"

echo -e "\n${GREEN}Top 5 response status codes:\n"
# Get response status codes and count them
awk '{print $9}' "$1" | sort | uniq -c | sort -nr | head -n 5 | awk -v green="$GREEN" -v blue="$BLUE" -v nc="$NC" '{printf "%s%6s%s %s%s%s\n", green, $1, nc, blue, $2, nc}'
echo -e "${GREEN}----------------------------------------\n"

echo -e "\n${GREEN}Top 5 user agents${NC}"
# Get user agents and count them
awk '{print $12}' "$1" | sort | uniq -c | sort -nr | head -n 5 | awk -v green="$GREEN" -v blue="$BLUE" -v nc="$NC" '{printf "%s%6s%s %s%s%s\n", green, $1, nc, blue, $2, nc}'
echo -e "${GREEN}----------------------------------------\n"
