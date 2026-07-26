#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Herdr
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🐑
# @raycast.packageName Herdr

# Documentation:
# @raycast.description Focus the herdr window if open, otherwise launch it in Ghostty

# Try to focus the terminal titled 🐑; any failure (Ghostty closed, no 🐑
# match, permission error) falls through to launching a fresh one. The
# `is running` line keeps the bare `tell` from auto-launching Ghostty on
# cold start (neither its evaluation nor script compilation launches it —
# verified). stderr is silenced because the failure paths are normal
# control flow here, not real errors.
if ! osascript 2>/dev/null <<'EOF'
if application "Ghostty" is not running then error number 1
tell application "Ghostty"
    focus (item 1 of (every terminal whose name is "🐑"))
    activate
end tell
EOF
then
    # Launch herdr in a new Ghostty instance. The shell pins its own title
    # via an OSC escape before exec'ing herdr (per-surface, unlike the
    # instance-wide --title); herdr (a TUI) never changes it, so the next
    # run can find it.
    open -na Ghostty.app --args -e zsh -l -c 'printf "\033]0;🐑\007"; exec herdr'
fi
