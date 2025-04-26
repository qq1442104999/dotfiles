1) sudo pacman -S pipewire pipewire-pulse pipewire-audio pipewire-alsa
   sudo pacman -S pavucontrol
   sudo pacman -S bluez bluez-utils bluedevil # bluedevil 为gui蓝牙管理
   systemctl --user enable pipewire
   systemctl --user start pipewire
   systemctl --user enable pipewire-pulse
   systemctl --user start pipewire-pulse
   sudo systemctl enable bluetooth
   sudo systemctl start bluetooth
   sudo pacman -S blueman-applet
   sudo usermod -aG bluetooth $USER

2) sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/   #自动登陆
   sudo vim /etc/systemd/system/getty@tty1.service.d/autologin.conf
   [Service]
   ExecStart=
   ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin username %I $TERM

3) sudo pacman -S python-pyxdg 
   sudo pacman -S python-dbus-next 
   sudo pacman -S alsa-utils
   sudo pacman -S python-psutil 

4) sudo pacman -S network-manager-applet
   sudo pacman -S dunst
   sudo pacman -S rofi
 
5) sudo pacman -S fcitx5 fcitx5-qt fcitx5-gtk fcitx5-config-qt fcitx5-material-color fcitx5-im fcitx5-rime fcitx5-chinese-addons 

6) sudo pacman -S lxappearance
   sudo pacman -S arc-gtk-theme
   sudo pacman -S papirus-icon-theme
   sudo pacman -S breeze-gtk
   sudo pacman -S breeze-icons
   sudo pacman -S breeze
   sudo pacman -S qt6ct
   yay -S polkit 用户提权

7) /etc/X11/xorg.conf.d/10-monitor.conf

   Section "ServerLayout"
       Identifier "ServerLayout0"
       Option "BlankTime"  "10" 	  # 自动锁屏
       Option "StandbyTime" "20"   # 关闭屏幕
       Option "SuspendTime" "30"   # 挂起
       Option "OffTime" "60"       # 关机
   EndSection

8) 开启hibernate
   1. 确保已经有swap
   2. /etc/default/grub, GRUB_CMDLINE_LINUX_DEFAULT 添加 resume=/dev/nvme0n1p3
   3. /etc/mkinitcpio.conf, HOOKS添加resume，resume放在udev之后，如果有lvm，放在lvm之后
   4. /etc/systemd/logind.conf, 按下电源键进入休眠 合盖挂起 半小时后休眠
     HandlePowerKey=hibernate
     HandleLidSwitch=suspend-then-hibernate
     HandleLidSwitchDocked=suspend-then-hibernate
     HibernateDelaySec=30min
   5. sudo grub-mkconfig -o /boot/grub/grub.cfg
   6. sudo mkinitcpio -p linux

9) 编辑 /etc/systemd/logind.conf 文件：
   1. HandlePowerKey=hibernate
      IdleAction=suspend
      IdleActionSec=30min
   2. 编辑 /etc/systemd/sleep.conf 文件：
      [Sleep]
      AllowSuspend=yes
      AllowHibernation=yes
      AllowSuspendThenHibernate=yes
      SuspendState=mem
      HibernateDelaySec=60min

10) 使用 rsync 进行系统备份
    sudo rsync -aAXv / /mnt/backup --exclude={"/mnt/*","/proc/*","/sys/*","/dev/*","/lost+found/*","/tmp/*","/run/*","/media/*","/var/run/*","/var/lock/*","/swapfile"}

11) 还原系统
    1. 挂载目标如果你的系统崩溃了，或者你需要还原到另一个设备上，你首先需要挂载目标位置，假设是 /dev/sdX1：
    sudo mount /dev/sdX1 /mnt/restore
    2. 使用 rsync 进行还原,执行以下命令来还原备份到根目录（假设你已经在 Live CD 或 Live USB 环境中操作）：
    sudo rsync -aAXv /mnt/backup/ /mnt/restore/
    3. 更新 /etc/fstab 文件,如果你在还原后更改了系统的分区配置，确保更新 /etc/fstab 文件以便于系统启动。使用以下命令编辑文件：
    sudo nano /mnt/restore/etc/fstab

10) sudo pacman -S btrfs-progs
    1.
