#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Herdr
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🐑
# @raycast.packageName Herdr

# Documentation:
# @raycast.description Open or focus the Ghostty window running herdr

# Thin wrapper: all launch/focus/dedup logic lives in _ghostty-launch.sh
# (see its header). KEY "herdr" scopes the state file AND tells the helper
# how to probe liveness (a herdr process whose ancestry reaches Ghostty).
# CMD must not contain double quotes; zsh -l provides the login PATH
# (herdr lives in ~/.local/bin; it spawns agents like claude/opencode).
CMD="zsh -l -c 'herdr'"

exec "$(dirname "$0")/_ghostty-launch.sh" herdr "$CMD"
