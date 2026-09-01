#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$DIR"

echo "==> Checking flake"
nix flake check

echo
echo "==> Building Home Manager configuration without activation"
if command -v home-manager >/dev/null 2>&1; then
  home-manager build --flake "$DIR#delai"
else
  nix run github:nix-community/home-manager/release-26.05#homeManager -- build --flake "$DIR#delai"
fi

echo
echo "==> Success. Nothing has been activated."
