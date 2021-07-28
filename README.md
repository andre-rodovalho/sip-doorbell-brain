# The Project

This repository should contain the basis to help you build a simple, reliable and flexible VoIP / SIP intercom system for condos using free software only. 

We have Asterisk running as a Docker Container, this is our "brain" on the system. Various SIP clients can connect to it through the SIP protocol, the most relevant to the system being an IP doorbell like Niteray Q520, Fanvil i30 or similar.

Here is an example of how these devices are typically connected:

![Network Diagram](./SIP_Network_Diagram_plain.svg)
