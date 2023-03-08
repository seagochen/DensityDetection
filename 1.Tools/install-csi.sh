#!/bin/bash

# Update package repository index
sudo apt-get update

# Install necessary packages
sudo apt-get install build-essential linux-headers-$(uname -r) git-core aptitude libelf-dev

# Clone the modified Linux kernel code from the CSI tool GitHub repository
CSITOOL_KERNEL_TAG=csitool-$(uname -r | cut -d . -f 1-2)
# git clone https://github.com/dhalperi/linux-80211n-csitool.git
cd linux-80211n-csitool
git checkout ${CSITOOL_KERNEL_TAG}

# Build the modified wireless driver
make -j `nproc` -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/intel/iwlwifi modules
sudo make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/intel/iwlwifi INSTALL_MOD_DIR=updates modules_install
sudo depmod

# Clone the CSI tool supplementary code
cd ..
git clone https://github.com/dhalperi/linux-80211n-csitool-supplementary.git

# Install the modified firmware
for file in /lib/firmware/iwlwifi-5000-*.ucode; do sudo mv $file $file.orig; done
sudo cp linux-80211n-csitool-supplementary/firmware/iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/
sudo ln -s iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/iwlwifi-5000-2.ucode

# Build the netlink tool
cd linux-80211n-csitool-supplementary/netlink
make

# Activate the driver
sudo modprobe -r iwlwifi mac80211
sudo modprobe iwlwifi connector_log=0x1
sudo killall wpa_supplicant
