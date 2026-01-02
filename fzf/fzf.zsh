# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

export FZF_DEFAULT_COMMAND='fd --type f --color=never --hidden'
# bat doesn't work with any input other than the list of files
# it is not a good idea to add `--preview` option
#export FZF_DEFAULT_OPTS='--no-height --color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b'
export FZF_DEFAULT_OPTS="
    --color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b
    --bind 'ctrl-y:execute-silent(echo {} | pbcopy)+abort'
    "

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"
# export FZF_ALT_C_COMMAND='fd --type d . --color=never --hidden'
# export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"
export FZF_ALT_C_COMMAND=""

export FZF_COMPLETION_TRIGGER='**'


export FZF_TMUX=1
export FZF_TMUX_OPTS='-p80%,60%'

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.zsh"
# replace 'alt+c'
# bindkey "ç" fzf-cd-widget
# for vim
#bind -M insert "ç" fzf-cd-widget

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

cdft() {
   local file
   local dir
   file=$(fzf-tmux $FZF_TMUX_OPTS --preview 'bat --color=always --line-range :50 {}' +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

fo() {
  local file
  file=$(fzf +m -q "$1") && vim "$file"
}

fto() {
  local file
  file=$(fzf-tmux $FZF_TMUX_OPTS --preview 'bat --color=always --line-range :50 {}' +m -q "$1") && vim "$file"
}
