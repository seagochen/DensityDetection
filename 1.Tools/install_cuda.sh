#!/bin/bash

# 下载CUDA 10.1安装程序
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-ubuntu1604.pin
wget https://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.243_418.87.00_linux.run

# 复制cuda-ubuntu1604.pin文件到/etc/apt/preferences.d/目录中
sudo mv cuda-ubuntu1604.pin /etc/apt/preferences.d/cuda-repository-pin-600

# 添加CUDA软件源
sudo sh -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list'

# 更新软件包索引并安装CUDA Toolkit和驱动程序
sudo apt-get update
sudo apt-get -y install cuda --allow-unauthenticated

# 将CUDA安装目录添加到PATH和LD_LIBRARY_PATH环境变量中
echo 'export PATH=/usr/local/cuda-10.1/bin${PATH:+:${PATH