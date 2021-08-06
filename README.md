# The Project

This repository should contain the basis to help you build a simple, reliable and flexible VoIP / SIP intercom system for residential or commercial buildings using free software only. On the market, you should probably find companies naming this solution as "smart doorbell".

The system is composed of these parts:
- SIP server, the "brain" on the intercom system.
- Various SIP clients connecting from the local network or the internet. 
- The doorbell device. It's is a "fancy" SIP client able to control an electric door lock.

Here is an example of how these devices are typically connected:

![Network Diagram](./SIP_Network_Diagram_plain.svg)

The SIP protocol and various device types available on the market allow us to build a system to meet our needs. We can use doorbell devices like the Niteray Q520 or Fanvil i30 equipped with a built-in camera and a dial pad. Other options would be the Akuvox R26 or Algo 8201 door phones, equipped with a single dial button. There are several makers and models out there, we should only need to make any the adjustments required on the "brain".

We set up a SIP server running Asterisk on a Docker Container. On this repository, you should find helper scrips and the files required to build your Container. Asterisk on a Container is super lightweight so you can host your server on nearly any computer nowadays, including old laptops and Raspberry Pi models 3, 4 or similar.

# Disclaimer

Copyright (C) 2021-present Andre Campos Rodovalho.

This program is free software: you can redistribute it and/or modify it under the terms of the MIT License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; please check out the LICENSE file for more information.

**ASTERISK is a registered trademark of Sangoma Technologies Corp.**

**Docker is a registered trademark of Docker, Inc. in the United States and/or other countries. Docker, Inc.**

SVG icons used here came from [svgrepo.com](https://www.svgrepo.com)

All trademarks, logos and brand names are the property of their respective owners. All company, product and service names used in this software are for identification purposes only. Use of these names, trademarks and brands does not imply endorsement.
