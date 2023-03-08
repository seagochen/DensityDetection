#!/bin/bash

# 定义wpa_supplicant进程名
PROCESS_NAME=wpa_supplicant

# 检测进程是否在运行
if pgrep $PROCESS_NAME > /dev/null; then
  # 如果进程在运行，就停止它
  echo "Stopping $PROCESS_NAME process..."
  sudo killall $PROCESS_NAME
  echo "$PROCESS_NAME process stopped."
fi

# 激活CSI驱动
sudo modprobe -r iwlwifi mac80211
sudo modprobe iwlwifi connector_log=0x1
sudo modprobe iwldvm

# 打印激活CSI驱动的信息
echo "CSI driver activated."

# 启动CSIlog_to_file
sudo ./netlink/log_to_file csi.dat
