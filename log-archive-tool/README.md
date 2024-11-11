# Log Archive Tool

A Bash script that automatically archives log files and cleans up the originals. The tool installs itself as a system command for easy access.

## Features

- 📦 Creates compressed archives with timestamps
- 🗂️ Preserves directory structure
- 🧹 Automatically cleans up original files after archiving
- 🛠️ Self-installing as system command
- 🔒 Safe archiving (preserves archive directory)

## Installation

1. Clone this repository:
2. Make the script executable and install:

```bash
chmod +x log-archive-tool.sh
sudo ./log-archive-tool.sh
```


## Requirements

- Bash shell
- tar and gzip utilities (standard on most Unix-like systems)
- sudo privileges (for installation only)

## File Naming

Archives are named using the following format:
log_archive_YYYY-MM-DD-HH-MM.tar.gz

## Safety Features

- Won't delete archive directory
- Checks for valid input directory
- Requires sudo only for installation
- Preserves directory structure in archives