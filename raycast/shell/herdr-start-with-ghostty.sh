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

# No existing herdr window -> launch one, pinning its title to 🐑 so the next
# run can find it. The title stays 🐑 because herdr (a TUI) never changes it.
if [ "$focused" != "focused" ]; then
    open -na Ghostty.app --args --title="🐑" -e zsh -l -c herdr
fi
