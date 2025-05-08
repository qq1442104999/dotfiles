# 1. 设置补全路径（必须在 compinit 之前）
fpath=(~/dotfiles/.zsh/plugins/zsh-completions/src $fpath)

# 2. 初始化补全系统
autoload -Uz compinit && compinit

# 3. 加载 fzf-tab（在 compinit 之后，但在其他插件之前）
source ~/dotfiles/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# 4. 加载其他插件（自动建议、语法高亮等）
source ~/dotfiles/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/dotfiles/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/dotfiles/.zsh/plugins/Extract/extract.sh
#source ~/dotfiles/.zsh/plugins/fzf-tab-source/*.plugin.zsh

#-----------------------------------------------------
ZSH_CACHE_DIR="$HOME/dotfiles/.zsh/cache"
SHORT_HOST=${HOST/.*/}
autoload -Uz add-zsh-hook
zmodload -i zsh/complist
unsetopt correct
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

autoload -U colors && colors  # 启用颜色
setopt auto_cd       # 直接输入目录名即可 cd
setopt multios       # 支持多输出流重定向
setopt prompt_subst  # 动态提示符

HISTFILE="$HOME/dotfiles/.zsh/cache/zshhistory"
HISTSIZE=50000
SAVEHIST=10000

setopt extended_history          # 每条历史有时间戳
setopt hist_expire_dups_first    # 优先删除重复命令
setopt hist_ignore_dups          # 连续重复命令不记录
setopt hist_ignore_space         # 前面有空格的命令不记录
setopt hist_verify               # 回显历史命令再执行
setopt inc_append_history        # 命令执行完实时写入历史文件
setopt share_history             # 多个终端共享历史

#set -o emacs
bindkey -e  # 使用 Emacs 风格的键位（默认）

bindkey '^[[1;5C' forward-word   # [Ctrl+→] 向前移动一个单词
bindkey '^[[1;5D' backward-word  # [Ctrl+←] 向后移动一个单词

# [↑]/[↓] 智能历史搜索（前缀匹配）
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search  # ↑

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search  # ↓

grep-flag-available() {
    echo | grep $1 "" >/dev/null 2>&1
}
GREP_OPTIONS=""
if grep-flag-available --color=auto; then
    GREP_OPTIONS+=" --color=auto"
fi
VCS_FOLDERS="{.bzr,CVS,.git,.hg,.svn}"

if grep-flag-available --exclude-dir=.cvs; then
    GREP_OPTIONS+=" --exclude-dir=$VCS_FOLDERS"
elif grep-flag-available --exclude=.cvs; then
    GREP_OPTIONS+=" --exclude=$VCS_FOLDERS"
fi
alias grep="grep $GREP_OPTIONS"

source ~/dotfiles/.zsh/config/git.zsh
source ~/dotfiles/.zsh/config/hook.zsh
source ~/dotfiles/.zsh/config/fzf.zsh