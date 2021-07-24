#!/bin/bash

LOG_PATH="/home/data/scripts/scripts.log"
DATE=$(date +"%d-%m-%Y %H:%M")

declare -a LOGS_TO_KEEP

# Building array of log files to keep.
# Format is '/path/to/file;NumberOfLinesToRetain'
LOGS_TO_KEEP[0]='/home/data/logs/messages;300000'
LOGS_TO_KEEP[1]='/home/data/scripts/scripts.log;10000'

for LOG in "${LOGS_TO_KEEP[@]}"
do
    # turn string '/path/to/file;NumberOfLinesToRetain' into
    # array ['/path/to/file', 'NUMBER_OF_LINES']
    IFS=";" read -r -a arr <<< "${LOG}"

    PATH="${arr[0]}"
    NUM="${arr[1]}"

    echo "$(/usr/bin/tail -n $NUM $PATH)" > $PATH
    echo "[$DATE] Removed older files from $PATH" >> $LOG_PATH
done

