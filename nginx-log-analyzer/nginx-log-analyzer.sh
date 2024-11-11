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
NC='\033[0m' # No Color

echo -e "\n${GREEN}Top 5 IP addresses with the most requests:${NC}"
# Get IP addresses and count them
awk '{print $1}' "$1" | sort | uniq -c | sort -nr | head -n 5

# Get most requested paths and count them
awk '{print $7}' "$1" | sort | uniq -c | sort -nr | head -n 5

# Get response status codes and count them
awk '{print $9}' "$1" | sort | uniq -c | sort -nr | head -n 5

# Get user agents and count them
awk '{print $12}' "$1" | sort | uniq -c | sort -nr | head -n 5