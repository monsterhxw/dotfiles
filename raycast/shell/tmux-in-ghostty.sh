#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Tmux
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📟
# @raycast.packageName Tmux

# Documentation:
# @raycast.description Open or focus the Ghostty window attached to tmux (session "lab")

# Thin wrapper: all launch/focus/dedup logic lives in _ghostty-launch.sh
# (see its header). KEY "tmux-lab" scopes the state file AND tells the helper
# how to probe liveness (a ghostty client attached to session "lab").
# CMD must not contain double quotes; zsh -l provides the login PATH
# (tmux lives in MacPorts).
CMD="zsh -l -c 'tmux new -A -s lab'"

exec "$(dirname "$0")/_ghostty-launch.sh" tmux-lab "$CMD"
