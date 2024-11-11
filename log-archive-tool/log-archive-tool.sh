#! /bin/bash

# Check if directory argument is provided
if [ -z "$1" ]; then
    echo "Error: Please provide a log directory"
    exit 1
fi

# Check if directory exists and is readable
if [ ! -d "$1" ] || [ ! -r "$1" ]; then
    echo "Error: Directory '$1' does not exist or is not readable"
    exit 1
fi

log_directory=$1
date=$(date +%Y-%m-%d-%H-%M)

# Create archive directory if it doesn't exist
archive_dir="${log_directory}/archives"
mkdir -p "$archive_dir"

# Create the archive in the new directory
find "$log_directory" -type f | tar -czf "${archive_dir}/log_archive_${date}.tar.gz" -T -
