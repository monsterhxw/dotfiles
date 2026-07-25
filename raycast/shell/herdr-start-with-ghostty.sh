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
# Only trust a 🐑 match when a live herdr client exists: a herdr-named
# process (pgrep -x matches the executable name, argv-independent) that has
# a controlling terminal — the server runs detached (tty = ??). Without one,
# a 🐑 match is a stale Cmd+N window (--title is instance-wide config) or a
# crashed client's leftover surface, and must not be focused. No client also
# means nothing to focus, so the osascript below is skipped entirely.
#
# The `is running` line inside the script guards the bare `tell`: it does
# not launch Ghostty (evaluated outside the tell block, and compiling the
# tell block does not launch it either — verified), so a closed Ghostty
# skips straight to `open` below without spawning an extra (initial-command)
# instance and a second dock icon on cold start.
focused="none"
if ps -o tty= -p "$(pgrep -x herdr | paste -sd, -)" 2>/dev/null | grep -q ttys; then
    focused=$(osascript <<'EOF'
if application "Ghostty" is not running then return "none"
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
