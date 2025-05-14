# Created by newuser for 5.9

#fzf的默认环境变量
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#zsh的omz配置
#source ~/dotfiles/.config/omz/omz.zsh  
#export _OMZ_APPLY_PREEXEC_HOOK=true
#export _OMZ_APPLY_CHPWD_HOOK=true
#export _OMZ_APPLY_HISTORYBYFZF=true
source ~/dotfiles/.zsh/config.zsh
_apply_chpwd_hook
_apply_preexec_hook
_apply_historybyfzf

#指定使用nvim
export EDITOR=nvim
export VISUAL=nvim

#输入法环境变量
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export GLFW_IM_MODULE=ibus

#QT主题
export QT_QPA_PLATFORMTHEME=qt6ct
export QT_QPA_PLATFORMTHEME=qt5ct

#GTK主题
export GTK_THEME=Breeze-Dark
# export DESKTOP_SESSION=gnome

#tldr的中文配置
export TLDR_LANGUAGE="zh"

#zoxide的初始化
eval "$(zoxide init zsh)"
export _ZO_FUZZY=0

#Starship命令提示符
eval "$(starship init zsh)"

#增强 less 命令的功能
eval "$(lesspipe.sh)"

#登陆自启动X
[ -z $DISPLAY ] && [ $(tty) = "/dev/tty1" ] && startx

#yazi文件浏览器退出 Yazi 时更改当前工作目录的功能
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

#别名
alias dotfiles='cd ~/dotfiles && stow -t ~ . --adopt --ignore="(^\.git$|^README\.md$|^wallpaper$|^\.zsh$)"'
alias v='nvim'
alias l='exa -l -a --icons --group-directories-first'
