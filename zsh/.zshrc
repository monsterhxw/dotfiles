# Amazon Q pre block. Keep at the top of this file.
# [[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# Q pre block. Keep at the top of this file.

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
# orb and orbctl completions
# $ mkdir -p $HOME/.zsh/completions/orbstack
# $ orb completion zsh > $HOME/.zsh/completions/orbstack/_orb
# $ orbctl completion zsh > $HOME/.zsh/completions/orbstack/_orbctl
# fpath+=("$HOME/.zsh/completions/orbstack")

fpath+=("$HOME/.zsh/completions")

# oh my zsh
export ZSH=$HOME/.oh-my-zsh
# Let zsh-autosuggestions bind its widgets once, at the first prompt, instead of
# re-wrapping them on every precmd. The default exists only so that edits to the
# ZSH_AUTOSUGGEST_*_WIDGETS arrays inside a live session take effect without
# re-sourcing; it does not pick up widgets other tools define later. Measured on
# this config: identical widget table (206 wrapped, one bind generation) with and
# without, and ~20ms off every prompt. Only being *set* matters, not the value,
# and it must come before the plugin loads below.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
plugins=(
  git 
  vi-mode
  fzf-tab
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-osx-autoproxy
  macports
  you-should-use
)
zstyle ':omz:update' mode disabled
# See: https://github.com/ohmyzsh/ohmyzsh/wiki/Settings/067cf4e22fdf9d4e0d7df920cdd3166ec16ae657#disable_auto_title
DISABLE_AUTO_TITLE="true"
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
zstyle ':completion:*' ignored-patterns '.DS_Store'
zstyle ':completion:*:(rm|trash):*' ignored-patterns
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':completion:*' special-dirs false # Ignore ./ and ../
[[ -n $TMUX ]] && zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# source
[[ -f "$HOME/.zsh/aliases.zsh" ]] && source "$HOME/.zsh/aliases.zsh"
[[ -f "$HOME/.zsh/functions.zsh" ]] && source "$HOME/.zsh/functions.zsh"
[[ -f ~/.config/fzf/fzf.zsh ]] && source ~/.config/fzf/fzf.zsh
[[ -f ~/.atuin/bin/env ]] && source ~/.atuin/bin/env

# export
# X Desktop Group (Freedesktop)
export XDG_CONFIG_HOME="$HOME/.config"
# MySQL@5.7
# export PATH="$PATH:/usr/local/opt/mysql@5.7/bin"
export LDFLAGS="-L/usr/local/opt/mysql@5.7/lib:$LDFLAGS"
export CPPFLAGS="-I/usr/local/opt/mysql@5.7/include:$CPPFLAGS"
export PKG_CONFIG_PATH="/usr/local/opt/mysql@5.7/lib/pkgconfig:$PKG_CONFIG_PATH"
# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/.ripgreprc"
java() {
  unfunction java
  export JAVA_HOME=$(/usr/libexec/java_home -v 21)
  java "$@"
}
# Neovim
export EDITOR=nvim
export VISUAL=nvim

# eval
# Homebrew
eval "$(/usr/local/bin/brew shellenv)"
# Startship
eval "$(starship init zsh)"
# Atuin
## See https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin
eval "$(atuin init zsh --disable-ctrl-r)"
# 如果 atuin 在第一个位置，就把它移到最后
if [[ "${ZSH_AUTOSUGGEST_STRATEGY[1]}" == "atuin" ]]; then
    # 移除第一个元素 atuin 并添加到末尾
    ZSH_AUTOSUGGEST_STRATEGY=("${ZSH_AUTOSUGGEST_STRATEGY[@]:1}" "atuin")
fi
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
# mise
eval "$($HOME/.local/bin/mise activate zsh)"


# Q post block. Keep at the bottom of this file.
# Amazon Q post block. Keep at the bottom of this file.
# [[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Amp CLI
export PATH="$HOME/.amp/bin:$PATH"

# Ghostty runs this itself in shells it spawns directly: it points ZDOTDIR at its
# own dir, whose .zshenv sources ours and then runs the integration -- all before
# .zshrc is read. This line is for interactive shells that inherit
# GHOSTTY_RESOURCES_DIR but not ZDOTDIR: `exec zsh`, tmux panes, agents spawned by
# herdr. Re-sourcing an already-initialized shell is a ~2ms no-op (the script
# returns early on $_ghostty_state), and non-interactive shells (zsh -l -c) never
# read .zshrc in the first place.
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi

# Stop leaking $fpath to child processes. Keep the value, drop only the export.
#
# `brew shellenv` (above) runs `export FPATH`, so every child shell inherits the
# fully-built fpath and oh-my-zsh appends its plugin dirs on top again: 18 -> 50
# -> 65 entries, one round of duplicates per nesting level. oh-my-zsh compares
# $fpath against the `#omz fpath:` line inside $ZSH_COMPDUMP and `rm -f`s the
# dump on any mismatch, so pristine shells (new terminal window) and nested ones
# (tmux panes, spawned agents) kept invalidating each other's cache -- every cold
# start paid a full compinit rebuild, ~1.7s.
#
# Nothing here needs FPATH from the environment: brew's site-functions dir and
# the stock zsh functions are in zsh's compiled-in default fpath, and fzf-tab
# re-adds its own lib dir on load. Must stay last -- anything sourced after that
# calls `export FPATH` would undo it.
typeset +x FPATH
