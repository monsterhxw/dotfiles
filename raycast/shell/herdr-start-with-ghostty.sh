#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Herdr
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🐑
# @raycast.packageName Ghostty

# Documentation:
# @raycast.description Launch a Ghostty window running herdr

open -na Ghostty --args -e /bin/zsh -l -c herdr
