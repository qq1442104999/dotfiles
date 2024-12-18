# Created by newuser for 5.9

#输入法环境变量
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

#使用bat作为man颜色输出
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

#字体缩放环境变量
  #export QT_FONT_DPI=144
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export GDK_DPI_SCALE=1.2
  #export QT_SCALE_FACTOR=1.4

#QT主题
#export QT_QPA_PLATFORMTHEME=gtk2
export QT_QPA_PLATFORMTHEME=qt5ct
#export QT_STYLE_OVERRIDE=kvantum
#export XDG_CURRENT_DESKTOP=GNOME

#zsh的omz配置
source ~/workspace/omz/omz.zsh  
export _OMZ_APPLY_PREEXEC_HOOK=true
export _OMZ_APPLY_CHPWD_HOOK=true

#终端代理
#export all_proxy="socks5://172.19.0.1:7891"
#export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
#export http_proxy=http://172.19.0.1:7890/ \
#       https_proxy=$http_proxy \
#       ftp_proxy=$http_proxy \
#       rsync_proxy=$http_proxy \
#       HTTP_PROXY=$http_proxy \
#       HTTPS_PROXY=$http_proxy \
#       FTP_PROXY=$http_proxy \
#       RSYNC_PROXY=$http_proxy


#登陆自启动X
[ -z $DISPLAY ] && [ $(tty) = "/dev/tty1" ] && startx
