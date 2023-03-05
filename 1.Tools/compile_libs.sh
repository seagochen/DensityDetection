#!/bin/bash

# Clone the modified Linux kernel code from the CSI tool GitHub repository
git clone https://github.com/spanev/linux-80211n-csitool.git

# Change to the cloned repository directory
cd linux-80211n-csitool

# Clone the CSI tool supplementary code
git clone https://github.com/dhalperi/linux-80211n-csitool-supplementary.git

# Build the netlink tool
make -C linux-80211n-csitool-supplementary/netlink

# Create the links to the netlink tool
ln -s $(pwd)/linux-80211n-csitool-supplementary/netlink ../netlink