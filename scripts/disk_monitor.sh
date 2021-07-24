#!/bin/sh

EXCLUDE_LIST="^Filesystem|tmpfs|cdrom|loop|udev|overlay|shm|^Sist"
ALERT_THRESHOLD=90
DATE=$(date +"%d-%m-%Y %H:%M")
HOSTNAME="Asterisk Server"
DESTINATION=""
LOG_PATH="/home/data/scripts/scripts.log"

df -H | grep -vE "$EXCLUDE_LIST" | awk '{ print $5 " " $1 }' | while read OUTPUT;
do
	#echo $OUTPUT
	USAGE=$(echo $OUTPUT | awk '{ print $1}' | cut -d'%' -f1  )
	PARTITION=$(echo $OUTPUT | awk '{ print $2 }' )
	echo "[$DATE] Reporting disk space usage: $PARTITION ($USAGE%)" >> $LOG_PATH

	if [ $USAGE -ge $ALERT_THRESHOLD ]; then
		echo "Subject: Alert!"$'\n'$'\n'"Running out of space \"$PARTITION ($USAGE%)\" on $HOSTNAME as on $DATE" | msmtp $DESTINATION
	fi
done

