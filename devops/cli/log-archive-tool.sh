#!/bin/bash

ARCHIVE_THIS=$1
DEFAULT_PATH=${2:-./logs_archive}

archive_logs(){
    TIME=$(date +"%Y%m%d_%s")
    ARCHIVE_NAME=logs_archive_$TIME.tar.gz
    tar -czf $ARCHIVE_NAME $ARCHIVE_THIS

    mv $ARCHIVE_NAME $DEFAULT_PATH
}

archive_logs