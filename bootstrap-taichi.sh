#!/usr/bin/env bash
# Takes a fresh Ubuntu box (taichi) from nothing to a built home-manager
# config from this repo, alongside the macOS setup.
# Run this once. After it finishes, use
#   home-manager switch --flake ~/.dotfiles#taichi
# for every later change.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

echo "==> Step 1: personalize the configured username"
# Do this before any sudo call: sudo resets $USER to root, so whoami has to
# run as the real interactive user first.
REAL_USER="$(whoami)"
FLAKE_USER="$(sed -nE 's/^[[:space:]]*taichiUser = "([^"]+)";.*/\1/p' "$DIR/flake.nix" | head -n1)"
if [ -z "$FLAKE_USER" ]; then
  echo "    Could not find the single \"taichiUser = \" line in flake.nix."
  echo "    Edit flake.nix yourself before continuing."
  exit 1
elif [ "$FLAKE_USER" != "$REAL_USER" ]; then
  echo "    flake.nix is configured for user \"$FLAKE_USER\", but you are \"$REAL_USER\"."
  read -r -p "    Rewrite flake.nix's \"taichiUser = \" line to \"$REAL_USER\"? [y/N] " REPLY
  if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
    sed -i -E "s/^([[:space:]]*taichiUser = \")[^\"]+(\";.*)/\1${REAL_USER}\2/" "$DIR/flake.nix"
    echo "    Updated. Review the change with: git diff flake.nix"
  else
    echo "    Skipped. Edit the single \"taichiUser = \" line in flake.nix yourself before continuing."
    exit 1
  fi
else
  echo "    flake.nix already matches \"$REAL_USER\", nothing to do."
fi

echo "==> Step 2: Nix on Linux (multi-user)"
if command -v nix >/dev/null 2>&1; then
  echo "    nix already installed, skipping"
else
  # The official installer installs the multi-user setup under sudo and
  # adds you to the nixbld group. Requires sudo access.
  NIX_INSTALLER="$(mktemp)"
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.nix.org/nix \
    -o "$NIX_INSTALLER"
  sudo sh "$NIX_INSTALLER" --no-confirm
  rm "$NIX_INSTALLER"
fi

echo "==> Step 3: symlink this repo to ~/.dotfiles"
# home.nix resolves its mkOutOfStoreSymlink paths through ~/.dotfiles, so this
# has to exist before the first switch or the build will fail to find them.
ln -sfn "$DIR" ~/.dotfiles

echo "==> Step 4: first home-manager switch (pinned to release-26.05)"
# home-manager isn't installed yet, so run it straight from the release
# branch this repo pins. This fetches the tool, not the config: the
# config applied is still pinned by this repo's flake.lock.
nix run github:nix-community/home-manager/release-26.05#homeManager -- \
  switch --flake ~/.dotfiles#taichi

echo "==> Step 5: put home-manager on PATH"
# Adds it to ~/.nix-profile so new shells find it without nix run.
nix profile add github:nix-community/home-manager/release-26.05#homeManager

echo "==> Done. Use: home-manager switch --flake ~/.dotfiles#taichi"
