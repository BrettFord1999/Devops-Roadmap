#!/bin/bash
#
# Log Archive Tool
#
# This script archives log files from a specified directory and cleans up the originals.
# It will install itself as a system-wide command on first run.
#
# Usage:
#   First time:   sudo ./log-archive-tool.sh
#   After install: log-archive-tool /path/to/logs
#
# Features:
#   - Creates compressed archives with timestamp
#   - Preserves directory structure
#   - Cleans up original files after archiving
#   - Self-installing as system command
#
# Arguments:
#   $1 - Directory containing log files to archive
#
# Output:
#   Creates archives/ directory with timestamped .tar.gz files
#
# Example:
#   log-archive-tool /var/log/myapp
#   Creates: /var/log/myapp/archives/log_archive_2024-01-01-14-30.tar.gz
#

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
find "$log_directory" -type f -not -path "${archive_dir}/*" -delete
