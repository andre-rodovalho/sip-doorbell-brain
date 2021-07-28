# The Project

This repository should contain the basis to help you build a simple, reliable and flexible VoIP / SIP intercom system for condos using free software only. 

We have Asterisk running as a Docker Container, this is our "brain" on the system. Various SIP clients can connect to it through the SIP protocol, the most relevant to the system being an IP doorbell like Niteray Q520, Fanvil i30 or similar.

Here is an example of how these devices are typically connected:

![Network Diagram](./SIP_Network_Diagram_plain.svg)

# Disclaimer

Copyright (C) 2021-present Andre Campos Rodovalho.

This program is free software: you can redistribute it and/or modify it under the terms of the MIT License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; please check out the LICENSE file for more information.

**ASTERISK is a registered trademark of Sangoma Technologies Corp.**

**Docker is a registered trademark of Docker, Inc. in the United States and/or other countries. Docker, Inc.**

SVG icons used here came from [svgrepo.com](https://www.svgrepo.com)

All trademarks, logos and brand names are the property of their respective owners. All company, product and service names used in this software are for identification purposes only. Use of these names, trademarks and brands does not imply endorsement.
