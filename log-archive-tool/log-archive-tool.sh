#!/bin/bash

# Self-installation logic
SCRIPT_PATH="/usr/local/bin/log-archive-tool"
if [ "$0" != "$SCRIPT_PATH" ]; then
    echo "Installing log-archive-tool command..."
    
    # Check if running with sudo
    if [ "$EUID" -ne 0 ]; then 
        echo "Please run with sudo for first-time installation"
        exit 1
    fi

    # Copy script to /usr/local/bin
    cp "$0" "$SCRIPT_PATH"
    chmod +x "$SCRIPT_PATH"
    echo "Installation complete! You can now use 'log-archive-tool' command"
    exit 0
fi

# Main script logic starts here
if [ -z "$1" ]; then
    echo "Error: Please provide a log directory"
    exit 1
fi

log_directory=$1
date=$(date +%Y-%m-%d-%H-%M)

# Create archive directory if it doesn't exist
archive_dir="${log_directory}/archives"
mkdir -p "$archive_dir"

# Create the archive in the new directory
find "$log_directory" -type f | tar -czf "${archive_dir}/log_archive_${date}.tar.gz" -T -
