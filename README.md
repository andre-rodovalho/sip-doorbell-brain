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
        * [Time Zone](./docker/Dockerfile#L5)
        * [Dockerfile path](./docker-compose.yml#L9)
        * [Volumes path](./docker/docker-compose.yml#L15)
- logs
    * No relevant files here yet. We configure our Container and scripts to create logs files under this directory.
- scripts
    * A few helper scripts to make your SIP server reliable in here.
- sounds
    * Directory where we put Audio to be used by Asterisk.

# Disclaimer

Copyright (C) 2021-present Andre Campos Rodovalho.

This program is free software: you can redistribute it and/or modify it under the terms of the MIT License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; please check out the LICENSE file for more information.

**ASTERISK is a registered trademark of Sangoma Technologies Corp.**

**Docker is a registered trademark of Docker, Inc. in the United States and/or other countries. Docker, Inc.**

SVG icons used here came from [svgrepo.com](https://www.svgrepo.com)

All trademarks, logos and brand names are the property of their respective owners. All company, product and service names used in this software are for identification purposes only. Use of these names, trademarks and brands does not imply endorsement.
