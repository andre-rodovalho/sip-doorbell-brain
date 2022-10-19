#!/usr/bin/env bash

LOG_PATH="/home/data/scripts/scripts.log"
DATE=$(date +"%d-%m-%Y %H:%M")
WAIT=30
MAX_LOOPS=10
LOOP=0

screen -S powerview -d -m bash -c 'cd /opt && exec bash'

while [ $LOOP -le $MAX_LOOPS ]
do
	PROCID=$(pidof java br.com.sms.powerview.servico.SMSysServico)

	if [ -z "$PROCID" ]
	then
       		echo "[$DATE] Check number $LOOP: Process is not running... Let's start it up" >> $LOG_PATH
		screen -S powerview -X stuff $'/opt/powerview/powerview start\n'
        	sleep ${WAIT}s
	else
        	echo "[$DATE] Check number $LOOP: Process is running, all good." >> $LOG_PATH
		break
	fi

	LOOP=$(( $LOOP + 1 ))
done
