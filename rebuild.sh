#!/usr/bin/env bash
#
# rebuild.sh – NixOS + Home Manager rebuild script for Taichi
#
# Usage: ./rebuild.sh
#
# This script:
# 1. Validates the flake
# 2. Applies the system configuration
# 3. Applies the Home Manager configuration
# 4. Sets Zsh as the login shell (if not already)
#
# After the first run, log out and back in (or reconnect SSH) to start using Zsh.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOSTNAME="taichi"

echo "🔍 Validating flake…"
nix flake check --impure

echo "🔧 Applying system configuration…"
sudo nixos-rebuild switch --flake ".#$HOSTNAME" --impure

echo "🏠 Applying Home Manager configuration…"
home-manager switch --flake ".#$HOSTNAME-dela" --impure

echo "🐚 Ensuring Zsh is the login shell…"
bash "$SCRIPT_DIR/scripts/set-login-shell-zsh.sh"

echo "✅ Rebuild complete!"
echo "💡 If this is your first time running this script, log out and back in (or reconnect SSH) to start using Zsh."
