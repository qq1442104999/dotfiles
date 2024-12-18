# Created by newuser for 5.9

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias nvi='nvim'

dadd() {
  git --git-dir=$HOME/.dotfiles --work-tree=$HOME add "$*"
}

#zsh的omz配置
source ~/.config/omz/omz.zsh  
export _OMZ_APPLY_PREEXEC_HOOK=true
export _OMZ_APPLY_CHPWD_HOOK=true

export EDITOR=nvim
export VISUAL=nvim

#输入法环境变量
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

#QT主题
export QT_QPA_PLATFORMTHEME=qt6ct
export QT_QPA_PLATFORMTHEME=qt5ct
# export XDG_CURRENT_DESKTOP=KDE


#登陆自启动X
[ -z $DISPLAY ] && [ $(tty) = "/dev/tty1" ] && startx
