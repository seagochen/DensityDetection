#!/bin/bash

# Check if the necessary directories are already present
if [ ! -d "linux-80211n-csitool" ] || [ -z "$(ls -A linux-80211n-csitool)" ] || \
   [ ! -d "linux-80211n-csitool/linux-80211n-csitool-supplementary" ] || \
   [ -z "$(ls -A linux-80211n-csitool/linux-80211n-csitool-supplementary)" ] || \
   [ ! -d "linux-80211n-csitool/Realtime-processing-for-csitool" ] || \
   [ -z "$(ls -A linux-80211n-csitool/Realtime-processing-for-csitool)" ]; then
    # Clone the modified Linux kernel code from the CSI tool GitHub repository
    git clone https://github.com/spanev/linux-80211n-csitool.git
    git clone https://github.com/dhalperi/linux-80211n-csitool-supplementary.git
    git clone https://github.com/lubingxian/Realtime-processing-for-csitool.git
fi

# Change to the cloned repository directory
cd linux-80211n-csitool

# Check out the correct release version
CSITOOL_KERNEL_TAG=csitool-$(uname -r | cut -d . -f 1-2)
git checkout ${CSITOOL_KERNEL_TAG}

# Update package repository index
sudo apt-get update

# Upgrade installed packages
sudo apt-get upgrade

# Install necessary packages
sudo apt-get install build-essential linux-headers-$(uname -r) git-core

# Build the modified wireless driver
sudo make -j `nproc` -C /lib/modules/$(uname -r)/build/ BUILD_DIR=$(pwd)/drivers/net/wireless/intel/iwlwifi modules

# Install the modified wireless driver
sudo sudo make -C /lib/modules/$(uname -r) BUILD_DIR=$(pwd)/drivers/net/wireless/intel/iwlwifi INSTALL_MOD_DIR=updates modules_install

# Move any existing iwlwifi-5000-*.ucode files to a backup location
for file in /lib/firmware/iwlwifi-5000-*.ucode; do sudo mv $file $file.orig; done

# Copy the modified firmware file
sudo cp linux-80211n-csitool-supplementary/firmware/iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/

# Create a symbolic link to the modified firmware file
sudo ln -s iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/iwlwifi-5000-2.ucode

# Build the netlink tool
make -C linux-80211n-csitool-supplementary/netlink

# Create the links to the netlink tool
sudo ln -s $(pwd)/linux-80211n-csitool-supplementary/netlink ../netlink

# Copy read_bf_socket.m to matlab folder
sudo cp ./Realtime-processing-for-csitool/matlab/read_bf_socket.m ./linux-80211n-csitool-supplementary/matlab/

# Copy log_to_server.c to netlink folder
sudo cp ./Realtime-processing-for-csitool/netlink/log_to_server.c ./linux-80211n-csitool-supplementary/netlink/

# Build log_to_server
cd linux-80211n-csitool-supplementary/netlink
gcc log_to_server.c -o log_to_server
