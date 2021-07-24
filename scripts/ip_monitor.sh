#!/bin/bash

DOMAIN="yourid.duckdns.org"
TOKEN="your-token"
LOG_PATH="/home/data/scripts/scripts.log"
CURRENT_PUBLIC_IP=$(curl --insecure https://api.ipify.org | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
RESOLVED_IP=$(dig +short $DOMAIN | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")
DUCKDNS_URL="https://www.duckdns.org/update?domains=$DOMAIN&token=$TOKEN&ip="
DATE=$(date +"%d-%m-%Y %H:%M")


if [ "$RESOLVED_IP" !=  "$CURRENT_PUBLIC_IP" ]
then
	# Log this event. Public IP has changed or there's an issue with connectivity with external services (DuckDNS, IPFY)
	echo "[$DATE] Resolved IP ($RESOLVED_IP) is different from Probed Public IP ($CURRENT_PUBLIC_IP)" >> $LOG_PATH
	# Update DDNS
	RESULT=$(curl --insecure --write-out "      %{http_code}" $DUCKDNS_URL)
	echo "[$DATE] Updating DDNS: "$(echo $RESULT | head -c 6)", "$(echo $RESULT | tail -c 4) >> $LOG_PATH
else
	#echo "[$DATE] Resolved and Probed IP address match - OK" >> $LOG_PATH
	exit 0
fi
