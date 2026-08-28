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

CLAUDE_FOUND=0
if command -v claude >/dev/null 2>&1; then
  CLAUDE_FOUND=1
else
  # sudo strips ~/.local/bin from PATH, which is where Claude Code normally
  # lives — check the real user's home (and root's) before warning.
  for CAND in "/root/.local/bin/claude" "$HOME/.local/bin/claude"; do
    [ -x "$CAND" ] && CLAUDE_FOUND=1 && break
  done
  if [ "$CLAUDE_FOUND" -eq 0 ] && [ -n "$SUDO_USER" ]; then
    SUDO_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    [ -n "$SUDO_HOME" ] && [ -x "$SUDO_HOME/.local/bin/claude" ] && CLAUDE_FOUND=1
  fi
fi

if [ "$CLAUDE_FOUND" -eq 0 ]; then
  echo "Note: the 'claude' CLI isn't installed yet. claude-bg launches it, so install"
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
