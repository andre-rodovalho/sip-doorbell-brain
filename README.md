# The Project

This repository should contain the basis to help you build a simple, reliable and flexible VoIP / SIP intercom system for residential or commercial buildings using free software only. On the market, you may find companies naming this solution as "smart doorbell".

The system is composed of:
- SIP server, the "brain" on the intercom system.
- Various SIP clients connecting from the local network or the internet. 
- The doorbell device. It's is a "fancy" SIP client able to control an electric door lock.

Here is an example of how the devices can be connected:

![Network Diagram](./SIP_Network_Diagram_plain.svg)

The SIP protocol and various device types available on the market allow us to build a system to meet our needs. We can use doorbell devices like the Niteray Q520 or Fanvil i30 equipped with a built-in camera and a dial pad. Other options would be the Akuvox R26 or Algo 8201 door phones, equipped with a single dial button. There are several makes and models out there, pick the hardware that works best for you, the functionality and details we can tailor on the "brain".

We set up a SIP server running Asterisk on a Docker Container. Asterisk is lightweight so we don't need lots of processing power, we can host the it on nearly any computer nowadays, including old laptops and Raspberry Pi models 3, 4 or similar.

Another way to architect the solution would be hosting the SIP server on a virtual server far away from your local network. This project can help you if this is what you are looking into but deeper adjustments to the configuration templates would be required.

# Table of Contents

- conf
    * This directory contains Asterisk configuration files. The most relevant files are:
        * The [extensions.conf](./conf/extensions.conf) file is the dialplan, here we configure the dial groups and call route logic.
        * The [pjsip.conf](./conf/pjsip.conf) contains critical resource configuration like SIP users/clients credentials and other network configuration. Set [local_net](./conf/pjsip.conf#L5), [external_media_address](./conf/pjsip.conf#L10) and [external_signaling_address](./conf/pjsip.conf#L11) as required. Clients configuration start on [line 51](./conf/pjsip.conf#L51).
- docker
    * Our Container image recipe is the [Dockerfile](./docker/Dockerfile) and the [docker-compose.yml](./docker/docker-compose.yml) help us configure our environment. Some settings you may want to update are:
        * [Asterisk version](./docker/Dockerfile#L3)
        * [Time Zone](./docker/docker-compose.yml#L5)
        * [Dockerfile path](./docker/docker-compose.yml#L9)
        * [Volumes path](./docker/docker-compose.yml#L15)
- logs
    * No relevant files here yet. We configure our Container and scripts to create logs files under this directory.
- scripts
    * Here we have a few helper scripts to run our SIP server reliably:
        * The [crontab_bkp](./scripts/crontab_bkp) file is an example/suggested crontab file.
        * The [disk_monitor.sh](./scripts/disk_monitor.sh) script helps monitor storage space usage by sending email notifications using msmtp.
        * The [logs_monitor.sh](./scripts/logs_monitor.sh) script helps to keep the log files size under control reducing unnecessary storage space usage.
        * The [ip_monitor.sh](./scripts/ip_monitor.sh) is useful for dynamic IP users. This script monitors a given hostname records and updates it as needed on the [duckdns.org](https://www.duckdns.org/) DDNS service.
        * The [reference_IP.txt](./scripts/reference_IP.txt) file is a control file used by the sip_monitor.sh script.
        * The [sip_monitor.sh](./scripts/sip_monitor.sh) script monitors the reference_IP.txt and restarts the SIP server Container as needed due to an IP address change.
        * The [scripts.log](./scripts/scripts.log) file is where the scripts store actions/events/debug information.
- sounds
    * Directory where we store audio/media to be used by Asterisk, our SIP server.

# Installation process
The steps are the same on any Linux distro but the commands would only work on a debian-like distros.

1. Install the Operating system on your hardware. Get OpenSSH server ready so you can access it remotely.
1. Connect to the server
    ```
    ssh user@serverIP
    sudo su
    ```
1. Create the directory where the project files should  sit in
    ```
    mkdir -p /home/data/
    ```
1. Install required software
    ```
    apt install git msmtp docker.io docker-compose
    ```
1. Clone this repository
    ```
    git clone https://gitlab.com/andre.rodovalho/sip-doorbell-brain.git /home/data2/sip-doorbell-brain/
    ```
1. Copy the required files and directories
    ```
    cp -r /home/data2/sip-doorbell-brain/{conf,docker,logs,scripts,sounds} /home/data/
    ```
1. Build the SIP server Container
    ```
    docker-compose -f /home/data/docker/docker-compose.yml build
    ```
1. Configure an [SMTP server for msmtp](https://www.google.com/search?q=configure+msmtp)
    ```
    nano ~/.msmtprc # configure an SMTP server: 
    ```
1. Adjust the management scripts as required
    ```
    nano /home/data/scripts/disk_monitor.sh	# configure DESTINATION email address
    nano /home/data/scripts/ip_monitor.sh	# configure DOMAIN and TOKEN
    nano /home/data/scripts/sip_monitor.sh	# configure DOMAIN
    chmod 744 /home/data/scripts/*.sh	# make all scripts executable
    ```
1. Configure your SIP server
    ```
    nano /home/data/conf/extensions.conf	# configure extensions
    nano /home/data/conf/pjsip.conf		# configure SIP clients credentials
    ```
1. Start up the SIP server
    ```
    docker-compose -f /home/data/docker/docker-compose.yml up -d
    ```
1. Configure a SIP client
1. Try connecting to the server
1. Troubleshooting connectivity issues (if needed)
    ```
    docker exec -it sipserver asterisk -rvvv
    ```
1. Configure required scheduled jobs
    ```
    crontab -e
    ```
## Additional (recommended) steps
1. Install fail2ban
	```
	apt install fail2ban
	```
1. Configure a custom jail to stop brute-force attacks
	```
	nano /etc/fail2ban/jail.local
	```
	* The file contents can look like the below:
	```
	[DEFAULT]
	ignoreip = 127.0.0.0/8 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16

	[asterisk]
	enabled  = true
	filter = asterisk
	port     = 5060
	action   = iptables-allports[name=asterisk, protocol=all]
	logpath  = /home/data/logs/messages
	maxretry = 10
	findtime = 1800
	bantime = 3d
	#backend = auto

	[recidive]
	enabled  = true
	maxretry = 3
	logpath  = /var/log/fail2ban.log
	#banaction = %(banaction_allports)s
	action   = iptables-allports[name=recidive, protocol=all]
	bantime  = 1m
	findtime = 3d
	```
1. Restart the service to apply changes
    ```
    systemctl restart fail2ban
    ```
1. Enable the service
    ```
    systemctl enable fail2ban
    ```

# Note
We won't cover the steps to configure your modem/router/NAT settings here. You would need to configure your equipment to forward ports 5060 and the 10000-20000 range to your server in order to expose the SIP server to the public. Check your equipment user's manual for instructions.

# Disclaimer

Copyright (C) 2021-present Andre Campos Rodovalho.

This program is free software: you can redistribute it and/or modify it under the terms of the MIT License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; please check out the LICENSE file for more information.

**ASTERISK is a registered trademark of Sangoma Technologies Corp.**

**Docker is a registered trademark of Docker, Inc. in the United States and/or other countries. Docker, Inc.**

SVG icons used here came from [svgrepo.com](https://www.svgrepo.com)

All trademarks, logos and brand names are the property of their respective owners. All company, product and service names used in this software are for identification purposes only. Use of these names, trademarks and brands does not imply endorsement.
