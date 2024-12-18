#!/bin/bash
DEVICE_MAC="50:88:11:2A:A5:53"  # 替换为你的设备MAC地址

# 检查设备是否已连接
if ! bluetoothctl info $DEVICE_MAC | grep -q 'Connected: yes'; then
    # 如果未连接，则尝试连接
    bluetoothctl connect $DEVICE_MAC
fi

