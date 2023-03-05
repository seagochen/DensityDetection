#!/bin/bash

# Unload the iwlwifi module
sudo modprobe -r iwlwifi mac80211

# Load the iwlwifi module with default options
sudo modprobe iwlwifi