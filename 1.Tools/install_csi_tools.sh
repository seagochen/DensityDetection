#!/bin/bash

# Set color variables
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Get the current kernel version
kernel_version=$(uname -r)

# Check if the necessary directories are already present
if [ ! -d "linux-80211n-csitool" ] || [ -z "$(ls -A linux-80211n-csitool)" ]; then
    # Clone the modified Linux kernel code from the CSI tool GitHub repository
    git clone https://github.com/spanev/linux-80211n-csitool.git
fi

# Change to the cloned repository directory
cd linux-80211n-csitool

# Check if the necessary directories are already present
if [ ! -d "linux-80211n-csitool-supplementary" ] || \
   [ -z "$(ls -A linux-80211n-csitool-supplementary)" ]; then
    git clone https://github.com/dhalperi/linux-80211n-csitool-supplementary.git
fi

if [ ! -d "Realtime-processing-for-csitool" ] || \
   [ -z "$(ls -A Realtime-processing-for-csitool)" ]; then 
    git clone https://github.com/lubingxian/Realtime-processing-for-csitool.git
fi

# Check out the correct release version based on kernel version
CSITOOL_KERNEL_TAG=csitool-$(uname -r | cut -d . -f 1-2)
git checkout $CSITOOL_KERNEL_TAG

# Update package repository index
echo "${GREEN}Updating package repository index...${NC}"
sudo apt-get update

# Install necessary packages
echo "${GREEN}Installing necessary packages...${NC}"
sudo apt-get install build-essential linux-headers-$(uname -r) git-core

# Build the modified wireless driver
echo "${GREEN}Building the modified wireless driver and netlink tool...${NC}"
sudo make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/iwlwifi modules
 
# Install the modified wireless driver
echo "${GREEN}Installing the modified wireless driver...${NC}"
sudo make -C /lib/modules/$(uname -r)/build M=$(pwd)/drivers/net/wireless/iwlwifi INSTALL_MOD_DIR=updates modules_install

# Update module dependencies
echo "${GREEN}Updating module dependencies...${NC}"
sudo depmod

# Move any existing iwlwifi-5000-*.ucode files to a backup location
echo "${GREEN}Backing up existing firmware files...${NC}"
for file in /lib/firmware/iwlwifi-5000-*.ucode; do sudo mv $file $file.orig; done

# Copy the modified firmware file
echo "${GREEN}Copying the modified firmware file...${NC}"
sudo cp linux-80211n-csitool-supplementary/firmware/iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/

# Create a symbolic link to the modified firmware file
echo "${GREEN}Creating a symbolic link to the modified firmware file...${NC}"
sudo ln -s iwlwifi-5000-2.ucode.sigcomm2010 /lib/firmware/iwlwifi-5000-2.ucode

# Build the netlink tool
echo "${GREEN}Building the netlink tool...${NC}"
make -C linux-80211n-csitool-supplementary/netlink

# Create the links to the netlink tool
echo "${GREEN}Creating the links to the netlink tool...${NC}"
sudo ln -s $(pwd)/linux-80211n-csitool-supplementary/netlink ../netlink

# Copy read_bf_socket.m to matlab folder
echo "${GREEN}Copying read_bf_socket.m to matlab folder...${NC}"
sudo cp ./Realtime-processing-for-csitool/matlab/read_bf_socket.m ./linux-80211n-csitool-supplementary/matlab/

# Copy log_to_server.c to netlink folder
echo "${GREEN}Copying log_to_server.c to netlink folder...${NC}"
sudo cp ./Realtime-processing-for-csitool/netlink/log_to_server.c ./linux-80211n-csitool-supplementary/netlink/

# Build log_to_server
echo "${GREEN}Building log_to_server...${NC}"
cd linux-80211n-csitool-supplementary/netlink
gcc log_to_server.c -o log_to_server

# Finished
echo "${GREEN}Finished!${NC}"
