# Amazon Q pre block. Keep at the top of this file.
# [[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# Q pre block. Keep at the top of this file.

# oh my zsh
export ZSH=$HOME/.oh-my-zsh
plugins=(
  git 
  vi-mode
  fzf-tab
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-osx-autoproxy
)
zstyle ':omz:update' mode disabled
source $ZSH/oh-my-zsh.sh
# vi-mode plugin
VI_MODE_SET_CURSOR=true 

# bindkey
# default is bindkey '^D' list-choices
bindkey '^D' delete-char
bindkey '^F' forward-char
bindkey '^B' backward-char
bindkey '^K' kill-line

# completion
# autoload -zU compinit && compinit # oh-my-zsh will call
# Include hidden files
_comp_options+=(globdots)
zstyle ':completion::complete:*:*:(files|globbed-files)' ignored-patterns '.DS_Store'
zstyle ':completion::complete:(rm|trash):*:globbed-files' ignored-patterns
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
[[ -n $TMUX ]] && zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# source
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -f ~/.zprofile ]] && source ~/.zprofile
[[ -f ~/.config/fzf/fzf.zsh ]] && source ~/.config/fzf/fzf.zsh

# export
# Homebrew
export PATH="/usr/local/sbin:$PATH"
# MySQL@5.7
# export PATH="$PATH:/usr/local/opt/mysql@5.7/bin"
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

# eval
# Startship
eval "$(starship init zsh)"
# Atuin
## See https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin
eval "$(atuin init zsh --disable-ctrl-r)"
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

# Q post block. Keep at the bottom of this file.
# Amazon Q post block. Keep at the bottom of this file.
# [[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
