#!/bin/bash

# Set color variables
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Unload the driver
echo "${GREEN}Unloading the driver...${NC}"
sudo modprobe -r iwldvm iwlwifi mac80211

# Reload the driver with CSI logging enabled
echo "${GREEN}Reloading the driver with CSI logging enabled...${NC}"
sudo modprobe iwlwifi connector_log=0x1

# Connect to an 802.11n access point
echo "${GREEN}Connecting to an 802.11n access point...${NC}"
# TODO: Replace the following line with the appropriate command to connect to an access point
# For example, you can use the iw and iproute2 utilities, or NetworkManager (nmcli or graphical applet)
# Or, you can let the system function as an access point by installing and configuring hostapd
# See supplementary material for configuration examples
# Once connected, proceed with logging CSI

# Begin logging CSI to a file
echo "${GREEN}Beginning CSI logging to a file...${NC}"
sudo ./netlink/log_to_file csi.dat
