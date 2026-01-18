# Go to dirs
alias godl='cd $HOME/Downloads'
alias gopj='cd $HOME/project'
alias godt='cd $HOME/Desktop'
alias goh='cd $HOME'
alias gotmp='cd $HOME/project/tmp'

# Replace remove 
alias rm='trash'

# Replace ll and ls
#alias ll='ls -lhas'
alias ls='lsd -NAv'
alias ll='lsd -Nlav'
alias lt='lsd --tree -Nav'

# brew upgrade with xargs Commanda
# alias brewupgrade='brew outdated | xargs -L 1 -p brew upgrade'

alias alacritty='/Applications/Alacritty.app/Contents/MacOS/alacritty'

alias tksv='tmux kill-server'

# AeroSpace Switch windows
alias ass='/usr/local/bin/aerospace list-windows --workspace focused | grep -v "^$(/usr/local/bin/aerospace list-windows --focused --format '%{window-id}')" | fzf --reverse | cut -f1 -d"|" | xargs /usr/local/bin/aerospace focus --window-id'

# Git
alias gdn='git diff --no-index'

# Neovim
alias nv='nvim'
alias nvd='nvim -d'
