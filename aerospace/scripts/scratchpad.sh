#!/usr/bin/env bash
# Ref: https://github.com/nikitabobko/AeroSpace/issues/510#issuecomment-2439585933

set -euo pipefail

APP_BUNDLE_ID="$1"
APP_NAME="$2"
IS_FLOAT="${3:-no}"

# Intel Chip Homebrew Path
AEROSPACE="/usr/local/bin/aerospace"
OSASCRIPT="/usr/bin/osascript"
OPEN="/usr/bin/open"

is_app_in_scope() {
  local scope="$1"
  $AEROSPACE list-windows $scope \
    --format '%{app-bundle-id}' 2>/dev/null \
    | grep -wq "$APP_BUNDLE_ID"
}

get_app_window_id() {
  local scope="$1"
  $AEROSPACE list-windows $scope \
    --format '%{window-id} %{app-bundle-id}' 2>/dev/null \
    | grep -w "$APP_BUNDLE_ID" \
    | cut -d ' ' -f1 \
    | head -n 1
}

wait_for_window() {
  local max_attempts=20 # 20 × 0.5S = 10S
  local sleep_seconds=0.5 

  for ((attempt=1; attempt<=max_attempts; attempt++)); do
    [[ -n $(get_app_window_id "--all") ]] && return 0
    sleep $sleep_seconds
  done

  exit 1
}

float_app() {
  if [ "$IS_FLOAT" = "float" ]; then
    # silent execution
    $AEROSPACE layout floating || true
    # Toggle between floating-centered and tiling layout
    # Floating-centered needs to depend on Raycast Window Management Center Command Hotkey
    # The Raycast Center Command Hotkey needs to be set to `ctrl + option + cmd + F2` (Key Code 120 = F2)
    $OSASCRIPT -e \
      'tell application "System Events"
         key code 120 using {control down, option down, command down}
       end tell'
  fi;
}

scratchpad() {
  if ! is_app_in_scope "--all"; then
    $OPEN -a "$APP_NAME"
  elif is_app_in_scope "--workspace focused"; then
    local win_id=$(get_app_window_id "--workspace focused")
    $AEROSPACE move-node-to-workspace NSP --window-id "$win_id"
  else
    local win_id=$(get_app_window_id "--all")
    local current_ws=$($AEROSPACE list-workspaces --focused)
    $AEROSPACE move-node-to-workspace "$current_ws" \
      --focus-follows-window \
      --window-id "$win_id"
    float_app
  fi
}

scratchpad
