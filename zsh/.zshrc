# Amazon Q pre block. Keep at the top of this file.
# [[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# Q pre block. Keep at the top of this file.

export ZSH=$HOME/.oh-my-zsh
plugins=(
  git 
  vi-mode
  # tmux
  fzf-tab
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-osx-autoproxy
)
zstyle ':omz:update' mode disabled
VI_MODE_SET_CURSOR=true # vi-mode
source $ZSH/oh-my-zsh.sh


# default is bindkey '^D' list-choices
bindkey '^D' delete-char
bindkey '^F' forward-char
bindkey '^B' backward-char
bindkey '^K' kill-line


# fzf-tab Include hidden files
_comp_options+=(globdots)
[[ -n $TMUX ]] && zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -f ~/.zprofile ]] && source ~/.zprofile
[[ -f ~/.config/fzf/fzf.zsh ]] && source ~/.config/fzf/fzf.zsh

# Homebrew
export PATH="/usr/local/sbin:$PATH"
## MySQL@5.7
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/mysql@5.7/lib"
export CPPFLAGS="-I/usr/local/opt/mysql@5.7/include"
export PKG_CONFIG_PATH="/usr/local/opt/mysql@5.7/lib/pkgconfig"
# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/.ripgreprc"


java() {
  unfunction java
  export JAVA_HOME=$(/usr/libexec/java_home -v 11)
  java "$@"
}

# better cd
# https://github.com/ajeetdsouza/zoxide
z() {
  unfunction z
  eval "$(zoxide init zsh)"
  z "$@"
}

zoxide() {
  unfunction zoxide
  eval "$(zoxide init zsh)"
  zoxide "$@"
}

# Startship
eval "$(starship init zsh)"
# Atuin
## See https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin
eval "$(atuin init zsh --disable-ctrl-r)"

# Q post block. Keep at the bottom of this file.
# Amazon Q post block. Keep at the bottom of this file.
# [[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
