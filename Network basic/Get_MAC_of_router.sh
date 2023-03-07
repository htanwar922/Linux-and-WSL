#!/bin/bash

# Get name of nameserver
cat /etc/resolv.conf

# trace route to nameserver for IP of router
traceroute 8.8.8.8

# Run arp to find MAC addresses
arp -a    # or
arp
