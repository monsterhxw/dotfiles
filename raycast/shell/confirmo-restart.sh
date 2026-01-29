#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Confirmo restart
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔄

# Documentation:
# @raycast.author Monster_Dump
# @raycast.authorURL https://raycast.com/Monster_Dump

APP_BUNDLE_ID="com.confirmo.app"

# Quit the app if running
osascript -e "tell application id \"$APP_BUNDLE_ID\" to quit" 2>/dev/null

# Wait for the app to fully quit
sleep 1

# Reopen the app
open -b "$APP_BUNDLE_ID"
