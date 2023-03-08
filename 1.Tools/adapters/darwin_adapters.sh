#!/bin/bash

# Get the list of physical interfaces
interfaces=$(ifconfig -l | tr ' ' '\n' | grep -v -e '^lo$')

# Loop through the interfaces and get their details
for interface in $interfaces; do
    # Get the MAC address
    hwaddr=$(ifconfig $interface | awk '/ether/ {print $2}')
    # Get the IP address and subnet mask
    ipaddr=$(ifconfig $interface | awk '/inet / {print $2}')
    netmask=$(ifconfig $interface | awk '/inet / {print $4}')
    # Get the gateway address
    gateway=$(route -n get default | awk "/interface: $interface/ {getline; print \$2}")
    echo "Interface: $interface"
    echo "HWAddr: $hwaddr"
    echo "IPAddr: $ipaddr"
    echo "Netmask: $netmask"
    echo "Gateway: $gateway"
    echo ""
done