#!/bin/sh

MIDTERM_THRESHOLD=2 # Load mid-term should not go over the number of cores for too long
DATE=$(date +"%d-%m-%Y %H:%M")
HOSTNAME="Asterisk Server"
DESTINATION=""
LOG_PATH="/home/data/scripts/scripts.log"

MIDTERM=$(cat /proc/loadavg | awk '{print $2}')

if [ $(echo "$MIDTERM > $MIDTERM_THRESHOLD" | bc) -ne 0 ]; then
	# Load is high
	echo "[$DATE] High load!!! Load average mid-term: $MIDTERM" >> $LOG_PATH
	echo "Subject: Alert!"$'\n'$'\n'"High load on $HOSTNAME as on $DATE" | msmtp $DESTINATION
else
	echo "[$DATE] Load average ok; mid-term: $MIDTERM" >> $LOG_PATH
fi
