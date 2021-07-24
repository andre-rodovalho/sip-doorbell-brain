#!/bin/bash

DOMAIN="yourid.duckdns.org"
LOG_PATH="/home/data/scripts/scripts.log"
REFERENCE_IP_PATH="/home/data/scripts/reference_IP.txt"
RESOLVED_IP=$(dig +short $DOMAIN | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
STORED_IP=$(cat $REFERENCE_IP_PATH)
DATE=$(date +"%d-%m-%Y %H:%M")

# Store resolved IP on file for future reference
# Sometimes this fails and the file is wiped out
echo $RESOLVED_IP > $REFERENCE_IP_PATH

# When there's a difference between  REFERENCE/STORED_IP and RESOLVED IP
# SIP server configuration is probably outdated, we need to restart it!
# As the nslookup sometimes won't work, we avoid restaring sipserver in case a variable is empty
if [ "$RESOLVED_IP" !=  "$STORED_IP" ] && [ "$RESOLVED_IP" != "" ] && [ "$STORED_IP" != "" ]
then
	# We need to reconfigure Asterisk
	RESULT=$(docker restart sipserver)
	echo "[$DATE] Resolved IP: $RESOLVED_IP ; Stored IP: $STORED_IP ; Restarting $RESULT" >> $LOG_PATH

	# Schedule another reboot 5 minutes from now
	$(sleep 5m; docker restart sipserver; echo "[$DATE] Restarted again as scheduled" >> $LOG_PATH) &
	exit 0
fi
