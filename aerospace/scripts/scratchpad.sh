#!/usr/bin/env bash
# Ref: https://github.com/nikitabobko/AeroSpace/issues/510#issuecomment-2439585933

set -euo pipefail

APP_BUNDLE_ID="$1"
APP_NAME="$2"
IS_FLOAT="${3:-unfloat}"
RESIZE="${4:-}"

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
  local max_attempts=20 # 20 × 0.4S = 8S
  local sleep_seconds=0.4

  for ((attempt=1; attempt<=max_attempts; attempt++)); do
    if window_id=$(get_app_window_id "--all") && [[ -n "$window_id" ]]; then
      return 0
    fi
    sleep $sleep_seconds
  done

  return 1
}

float_app() {
  if [ "$IS_FLOAT" = "float" ]; then
    # silent execution
    $AEROSPACE layout floating || true
    # Toggle between floating-centered and tiling layout
    # Floating-centered needs to depend on Raycast Window Management Center Command Deeplinks
    # - See: https://manual.raycast.com/deeplinks#block-d1a7b2b605124a539323503f225301e3
    $OPEN -g raycast://extensions/raycast/window-management/center
  fi;
}

resize_app() {
  local win_id="${1:-}"
  
  if [[ -n "$win_id" ]]; then
    $AEROSPACE focus --window-id "$win_id"
  fi

  if [[ "$IS_FLOAT" != "float" && -n "$RESIZE" ]]; then
    $AEROSPACE resize smart "$RESIZE"
  fi;
}

scratchpad() {
  if ! is_app_in_scope "--all"; then
    $OPEN -a "$APP_NAME"
    wait_for_window
    float_app
    resize_app
  elif is_app_in_scope "--workspace focused"; then
    local win_id=$(get_app_window_id "--workspace focused")
    if is_app_in_scope "--focused"; then
      $AEROSPACE move-node-to-workspace NSP --window-id "$win_id"
    else
      $AEROSPACE focus --window-id "$win_id"
      resize_app
    fi
  else
    local win_id=$(get_app_window_id "--all")
    local current_ws=$($AEROSPACE list-workspaces --focused)
    $AEROSPACE move-node-to-workspace "$current_ws" \
      --focus-follows-window \
      --window-id "$win_id"
    float_app
    resize_app "$win_id"
  fi
}

scratchpad
