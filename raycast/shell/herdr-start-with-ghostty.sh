#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Herdr
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🐑
# @raycast.packageName Ghostty

# Documentation:
# @raycast.description Focus the herdr window if open, otherwise launch it in Ghostty

# The launched window pins its title to 🐑 (via --title below), which Ghostty
# exposes as the terminal's `name`. Use Ghostty's native AppleScript to find
# that terminal and focus it (brings its window to front). Needs only
# Automation permission (prompted on first run), not Accessibility.
#
# Guard with `is running` first: a bare `tell application "Ghostty"` would
# auto-launch Ghostty just to run the query, spawning an extra (initial-command)
# instance and a second dock icon on cold start. Querying `is running` does not
# launch it, so when Ghostty is closed we skip straight to `open` below.
focused="none"
if [ "$(osascript -e 'application "Ghostty" is running')" = "true" ]; then
    focused=$(osascript <<'EOF'
tell application "Ghostty"
    set matches to (every terminal whose name is "🐑")
    if (count of matches) > 0 then
        focus (item 1 of matches)
        activate
        return "focused"
    end if
    return "none"
end tell
EOF
)
fi

# No existing herdr window -> launch one, pinning its title to 🐑 so the next
# run can find it. The title stays 🐑 because herdr (a TUI) never changes it.
if [ "$focused" != "focused" ]; then
    open -na Ghostty.app --args --title="🐑" -e zsh -l -c herdr
fi
