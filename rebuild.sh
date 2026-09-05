#!/usr/bin/env bash
# Rebuild the Home Manager environment for the current user on Taichi.
# Run with: bash rebuild.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
USER_NAME="$(id -un)"
# Pass the flake as an absolute file path so `builtins.getEnv` in flake.nix
# resolves to the runtime user; keep the working tree via --impure.
FLAKE="$SCRIPT_DIR#$USER_NAME"

cd "$SCRIPT_DIR"

echo "==> Checking flake"
nix flake check --impure

echo
echo "==> Building Home Manager configuration without activation"
home-manager build --impure --flake "$FLAKE"

echo
read -r -p "Apply Home Manager configuration for $USER_NAME? [y/N] " reply
case "$reply" in
  [yY]|[yY][eE][sS]) ;;
  *)
    echo "==> Nothing has been activated."
    exit 0
    ;;
esac

echo "==> Applying Home Manager configuration"
home-manager switch --impure --flake "$FLAKE"

echo "==> Ensuring Zsh is the login shell"
bash "$SCRIPT_DIR/scripts/set-login-shell-zsh.sh"

echo "==> Done. Reconnect SSH or log out/in to start a new Zsh login session."
