#!/bin/bash

# 设置信道号和带宽
CHANNEL=11
BANDWIDTH=HT20

# 获取无线网卡的接口名称
WLAN=$(ifconfig -a | grep "wlan" | awk '{print $1}')
echo "无线网卡接口名称：$WLAN"

# 启用CSI功能
sudo modprobe -r iwldvm
sudo modprobe iwldvm debug=0x1

# 开始记录CSI数据
sudo iw dev $WLAN set channel $CHANNEL $BANDWIDTH
sudo tcpdump -i $WLAN -U -s 65535 -w csi.log

echo "正在记录CSI数据，请按Ctrl+C停止记录..."

# 完成记录CSI数据
