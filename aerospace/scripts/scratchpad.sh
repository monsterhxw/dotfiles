#!/usr/bin/env bash
# Ref: https://github.com/nikitabobko/AeroSpace/issues/510#issuecomment-2439585933
set -euo pipefail

APP_BUNDLE_ID="$1"
IS_FLOAT="${2:-unfloat}"
RESIZE="${3:-}"

# Intel Chip Homebrew Path
AEROSPACE="/usr/local/bin/aerospace"
OPEN="/usr/bin/open"

# 获取指定范围内的应用窗口 ID（空则不存在）
get_window_id() {
  $AEROSPACE list-windows "$@" --format '%{window-id} %{app-bundle-id}' 2>/dev/null \
    | awk -v id="$APP_BUNDLE_ID" '$2 == id {print $1; exit}'
}

# 等待窗口出现（最多 5 秒）
wait_for_window() {
  for _ in {1..10}; do
    [[ -n "$(get_window_id --all)" ]] && return 0
    sleep 0.5
  done
  return 1
}

# 设置浮动并居中
float_and_center() {
  [[ "$IS_FLOAT" != "float" ]] && return
  $AEROSPACE layout floating || true
  $OPEN -g raycast://extensions/raycast/window-management/center
}

# 调整窗口大小
resize_window() {
  local win_id="${1:-}"
  [[ -n "$win_id" ]] && $AEROSPACE focus --window-id "$win_id"
  [[ "$IS_FLOAT" == "float" || -z "$RESIZE" ]] && return
  $AEROSPACE resize smart "$RESIZE"
}

# 主逻辑
main() {
  local win_all win_focused current_ws

  win_all=$(get_window_id --all)

  # 情况 1: 应用未运行 → 打开它
  if [[ -z "$win_all" ]]; then
    $OPEN -b "$APP_BUNDLE_ID"
    wait_for_window
    float_and_center
    resize_window
    return
  fi

  win_focused=$(get_window_id --workspace focused)

  # 情况 2: 应用在当前工作区
  if [[ -n "$win_focused" ]]; then
    # 已聚焦 → 隐藏到 NSP
    if [[ -n "$(get_window_id --focused)" ]]; then
      $AEROSPACE move-node-to-workspace NSP --window-id "$win_focused"
    # 未聚焦 → 聚焦它
    else
      $AEROSPACE focus --window-id "$win_focused"
      resize_window
    fi
    return
  fi

  # 情况 3: 应用在其他工作区 → 移动到当前工作区
  current_ws=$($AEROSPACE list-workspaces --focused)
  $AEROSPACE move-node-to-workspace "$current_ws" --focus-follows-window --window-id "$win_all"
  float_and_center
  resize_window "$win_all"
}

main
