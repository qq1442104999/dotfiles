#!/bin/sh

#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & #提权
udiskie --appindicator & #自动挂载u盘
#/usr/bin/prime-offload &  #optimus-manager
#optimus-manager-qt & #显卡
#lxsession &
fcitx5 &                   #输入法自启动
nm-applet &                #网络托盘
blueman-applet &           #蓝牙
xset r rate 500 20 &       #设置键盘延迟和速率
dunst -conf ~/.config/dunst.conf & #开启通知server
picom --config ~/.config/picom.conf  >> /dev/null 2>&1 & #picom
stalonetray  --max-geometry 1x1 --icon-gravity NE  --background '#282828' --window-layer top --geometry 8x1+1885+4 &
clash-verge &
sleep 1
feh --bg-fill --randomize ~/wallpaper/* &  #壁纸
numlockx &                 #在启动时激活 numlock
sleep 1
rfkill unblock bluetooth
