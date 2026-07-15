#!/bin/bash

# =====
# SCRIPT: archive_logs.sh
# DESCRIPTION: Compresses and archives log files using the following fields:
#   - ARCHIVE_THIS: Target file or directory path to compress ($1)
#   - DEFAULT_PATH: Destination directory path, defaults to ./logs_archive ($2)
#
# Usage: ./log-archive-tool.sh <target_files> <destination_path>
# Example: ./archive.sh /var/log /mnt/backup
# =====

ARCHIVE_THIS=$1
DEFAULT_PATH=${2:-./logs_archive}

archive_logs(){
    TIME=$(date +"%Y%m%d_%s")
    ARCHIVE_NAME=logs_archive_$TIME.tar.gz
    tar -czf $ARCHIVE_NAME $ARCHIVE_THIS

    mv $ARCHIVE_NAME $DEFAULT_PATH
}

archive_logs