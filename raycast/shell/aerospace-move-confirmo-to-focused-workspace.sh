#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title AeroSpace Move Confirmo to Focused Workspace
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🧑‍💻

# Documentation:
# @raycast.author Monster_Dump
# @raycast.authorURL https://raycast.com/Monster_Dump

# Get Confirmo window ID
WINDOW_ID=$(/usr/local/bin/aerospace list-windows --app-bundle-id com.confirmo.app --monitor all --format '%{window-id}' | head -n 1)
[[ -z "$WINDOW_ID" ]] && exit 0

# Get focused workspace
FOCUSED_WORKSPACE=$(/usr/local/bin/aerospace list-workspaces --focused)

# Move window to focused workspace
/usr/local/bin/aerospace move-node-to-workspace --focus-follows-window --window-id "$WINDOW_ID" "$FOCUSED_WORKSPACE" >/dev/null 2>&1
