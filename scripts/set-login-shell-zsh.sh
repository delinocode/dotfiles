#!/usr/bin/env bash
#
# set-login-shell-zsh.sh
#
# Sets Zsh as the login shell for the current user on NixOS.
# - Detects Zsh path via `command -v zsh`
# - Adds it to /etc/shells if missing (requires sudo)
# - Runs `sudo chsh -s <zsh_path> $(whoami)`
#
# Safe to run multiple times. Will ask for sudo password only when needed.

set -euo pipefail

TARGET_USER="$(whoami)"

# Detect Zsh path from the current environment (Nix profile)
ZSH_PATH="$(command -v zsh || true)"

if [[ -z "$ZSH_PATH" ]]; then
  echo "❌ Zsh not found in PATH. Make sure Zsh is installed via Nix/Home Manager first."
  exit 1
fi

echo "🔍 Detected Zsh at: $ZSH_PATH"
echo "👤 Target user: $TARGET_USER"

# Ensure Zsh path is in /etc/shells
if ! grep -qxF "$ZSH_PATH" /etc/shells; then
  echo "🔧 Adding Zsh to /etc/shells (requires sudo)…"
  echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
else
  echo "✅ Zsh already present in /etc/shells"
fi

# Get current login shell for the target user
CURRENT_SHELL="$(getent passwd "$TARGET_USER" | cut -d: -f7)"

if [[ "$CURRENT_SHELL" == "$ZSH_PATH" ]]; then
  echo "✅ Login shell for $TARGET_USER is already Zsh ($ZSH_PATH)"
  exit 0
fi

echo "🔧 Changing login shell for $TARGET_USER to Zsh (requires sudo)…"
sudo chsh -s "$ZSH_PATH" "$TARGET_USER"

echo "✅ Login shell updated. Re-login (or reconnect SSH) to start using Zsh."
