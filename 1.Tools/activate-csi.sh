#!/bin/bash

# Unload the iwlwifi module
sudo modprobe -r iwlwifi mac80211

# Load the iwlwifi module with the connector_log option
sudo modprobe iwlwifi connector_log=0x1

# Load the CSI tool netlink module
sudo modprobe iwldvm

# Start logging CSI data to a file
sudo ./netlink/log_to_file csi.dat
