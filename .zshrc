# Created by newuser for 5.9

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


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

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias nvi='nvim'

dam() {
  local gitdir=$HOME/.dotfiles
  local worktree=$HOME
  # 检查是否提供参数
  if [[ -z "$*" ]]; then
    echo "Usage: dam <files...>"
    return 1
  fi
  # 添加文件
  git --git-dir="$gitdir" --work-tree="$worktree" add "$@" || {
    echo "Error: Failed to add files."
    return 1
  }
  # 提交更改
  git --git-dir="$gitdir" --work-tree="$worktree" commit -m "Updated files: $*" || {
    echo "Error: Failed to commit changes."
    return 1
  }
  echo "Successfully added and committed: $*"
}
