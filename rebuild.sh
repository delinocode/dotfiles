#!/usr/bin/env bash
# Taichi-only rebuild script.
# Validates the flake, builds the Home Manager generation, then asks
# for confirmation before activating it.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$DIR"

"$DIR/scripts/check.sh"

echo
read -r -p "Apply Home Manager configuration for delai on Taichi? [y/N] " answer

case "$answer" in
  y|Y|yes|YES)
    echo "==> Applying Home Manager configuration"
    if command -v home-manager >/dev/null 2>&1; then
      exec home-manager switch --flake "$DIR#delai"
    else
      exec nix run github:nix-community/home-manager/release-26.05#homeManager -- switch --flake "$DIR#delai"
    fi
    ;;
  *)
    echo "==> Cancelled. Nothing has been changed."
    ;;
esac
