#!/usr/bin/env bash
# Takes a fresh Ubuntu box (Taichi) from nothing to a built Home Manager
# config from this repo. Run this once. After it finishes, use
#   ./rebuild.sh
# for every later change.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

echo "==> Step 1: Nix on Linux (multi-user)"
if command -v nix >/dev/null 2>&1; then
  echo "    nix already installed, skipping"
else
  sh <(curl -L https://nixos.org/nix/install) --daemon
fi

echo "==> Step 2: symlink this repo to ~/.dotfiles"
ln -sfn "$DIR" ~/.dotfiles

echo "==> Step 3: create the Home Manager lock file if missing"
if [ ! -f "$DIR/flake.lock" ]; then
  nix flake lock "$DIR"
fi

echo "==> Step 4: first Home Manager switch (release-26.05)"
nix run github:nix-community/home-manager/release-26.05#homeManager -- \
  switch --flake "$DIR#delai"

echo "==> Step 5: put home-manager on PATH"
nix profile add github:nix-community/home-manager/release-26.05#homeManager

echo "==> Done. Use: ./rebuild.sh for future changes."
