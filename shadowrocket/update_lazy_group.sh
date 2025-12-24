#!/usr/bin/env bash

# 远程配置文件 URL
REMOTE_URL="https://lowertop.github.io/Shadowrocket/lazy_group.conf"

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 本地配置文件路径
LOCAL_FILE="${SCRIPT_DIR}/config/lazy_group.conf"

echo "Downloading lazy_group.conf..."

# 下载配置文件
if curl -fsSL "${REMOTE_URL}" -o "${LOCAL_FILE}"; then
    echo "Successfully updated: ${LOCAL_FILE}"
else
    echo "Failed to download lazy_group.conf" >&2
    exit 1
fi
