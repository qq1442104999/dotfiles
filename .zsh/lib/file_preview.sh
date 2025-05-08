#! /usr/bin/env sh
mime=$(file -bL --mime-type "$1")
category=${mime%%/*}
if [ -d "$1" ]; then
    exa -l --color=always --no-user --no-time --icons --no-permissions --no-filesize "$1" 2>/dev/null || ls --color=always "$1" 2>/dev/null || ls -G "$1"
elif [ "$category" = text ]; then
    (bat -p --color=always "$1" || cat "$1") 2>/dev/null | head -1000
elif [ "$category" = image ]; then
    # 首先尝试使用 fzf-preview.sh
    fzf_preview_script="$HOME/dotfiles/.zsh/lib/fzf-preview.sh"
    if [ -x "$fzf_preview_script" ]; then
        "$fzf_preview_script" "$1" && exit 0
    fi
    echo "Image file detected, but fzf-preview.sh failed or not found"
else 
    echo $1 is a $category file
    (bat -p --color=always "$1" || cat "$1") 2>/dev/null | head -1000
fi
