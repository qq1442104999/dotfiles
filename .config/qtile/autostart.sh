#!/bin/sh

#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & #提权
#udiskie --appindicator & #自动挂载u盘
#/usr/bin/prime-offload &  #optimus-manager
#optimus-manager-qt & #显卡
   #lxsession &
fcitx5 &                   #输入法自启动
# nm-applet &                #网络托盘
blueman-applet &           #蓝牙
numlockx &                 #在启动时激活 numlock
xset r rate 200 20 &       #设置键盘延迟和速率
dunst -conf ~/.config/dunst.conf & #开启通知server
#/opt/clash-for-windows-bin/cfw & #clash_for_windows
   #xrandr --dpi 144 &
picom --config ~/.config/picom.conf  >> /dev/null 2>&1 & #picom
#sleep 1
#feh --bg-fill --randomize ~/workspace/wallpaper/* &  #壁纸
