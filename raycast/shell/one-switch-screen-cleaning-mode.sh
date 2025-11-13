#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title One Switch Screen Cleaning Mode
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🧹

# Documentation:
# @raycast.author Monster_Dump
# @raycast.authorURL https://raycast.com/Monster_Dump
# @raycast.description Toggle One Switch Screen Cleaning Mode by simulating keyboard shortcut

# Prerequisites:
#   - Set One Switch "Screen Cleaning Mode" shortcut to Ctrl+Opt+Cmd+Shift+F2 first
# Simulate Ctrl + Opt + Cmd + Shift + F2
/usr/bin/osascript -e 'tell application "System Events" to key code 120 using {control down, option down, command down, shift down}'
