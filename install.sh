#!/bin/bash
# Installs claude-bg to /usr/local/bin on any Ubuntu box.
#
#   curl -fsSL https://raw.githubusercontent.com/00itsm00/claude-bg/main/install.sh | sudo bash
#
set -e

REPO_RAW="https://raw.githubusercontent.com/00itsm00/claude-bg/main"
INSTALL_PATH="/usr/local/bin/claude-bg"

if [ "$(id -u)" -ne 0 ]; then
  echo "Run this as root (or with sudo)." >&2
  exit 1
fi

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux not found — installing..."
  apt-get update -qq
  apt-get install -y tmux
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "Note: the 'claude' CLI isn't on PATH yet. claude-bg launches it, so install"
  echo "Claude Code first if you haven't: https://docs.claude.com/en/docs/claude-code"
fi

if [ -f "$(dirname "$0")/claude-bg" ]; then
  # Running from a local clone — copy the local file instead of fetching it.
  cp "$(dirname "$0")/claude-bg" "$INSTALL_PATH"
else
  curl -fsSL "$REPO_RAW/claude-bg" -o "$INSTALL_PATH"
fi
chmod +x "$INSTALL_PATH"

echo "Installed claude-bg to $INSTALL_PATH"
echo ""
claude-bg
