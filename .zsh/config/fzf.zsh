export RUNEWIDTH_EASTASIAN=0
export FZF_DEFAULT_OPTS="--height 12 --scrollbar=▌▐ --info=inline-right --layout=reverse --history=$HOME/dotfiles/.zsh/cache/fzfhistory --preview '$HOME/dotfiles/.zsh/lib/file_preview.sh {}'"
export FZF_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build,dist,vendor} --type f --hidden"
export FZF_PREVIEW_COMMAND='bash $HOME/dotfiles/.zsh/lib/file_preview.sh {}'
#export FZF_CTRL_T_OPTS="--preview '$HOME/dotfiles/.zsh/lib/file_preview.sh {}'"

zstyle ':completion:complete:*:options' sort false
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':completion:*:descriptions' format "[%d]"
zstyle ':fzf-tab:*' group-colors $'\033[15m' $'\033[14m' $'\033[33m' $'\033[35m' $'\033[15m' $'\033[14m' $'\033[33m' $'\033[35m'
zstyle ':fzf-tab:*' prefix ''
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[ "$group" = "process ID" ] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:yay:*' fzf-preview 'yay -Qi $word || yay -Si $word'
zstyle ':fzf-tab:complete:pacman:*' fzf-preview 'pacman -Qi $word || pacman -Si $word'
zstyle ':fzf-tab:complete:(\\|)run-help:*' fzf-preview 'run-help $word'
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff --color=always $word'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview 'git show --color=always $word'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview '[ -f "$realpath" ] && git diff --color=always $word || git log --color=always $word'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bash $HOME/dotfiles/.zsh/lib/file_preview.sh ${(Q)realpath}'
zstyle ':fzf-tab:complete:*:*' fzf-flags --height=12 --scrollbar=▌▐ --info=inline-right --layout=reverse --multi --bind tab:toggle --marker='✓' --pointer='▶'

_apply_historybyfzf() {
    function historybyfzf() {
        local selected
        if [[ -n $LBUFFER ]]; then
            selected=$(fc -ln 1 | tac | awk '!seen[$0]++' | fzf --query="$LBUFFER")
        else
            selected=$(fc -ln 1 | tac | awk '!seen[$0]++' | fzf)
        fi

        if [[ -n $selected ]]; then
            BUFFER=$selected
            CURSOR=${#BUFFER}
            zle redisplay
        fi
    }
    zle -N historybyfzf
    bindkey '^r' historybyfzf
}

