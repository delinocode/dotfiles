#!/usr/bin/env bash
# Enable GPU support for Nix apps on non-NixOS (Pop!_OS, Ubuntu, etc.)
# Run this once after home-manager switch, or whenever GPU drivers need updating.

set -euo pipefail

echo ">> Activating GPU support for non-NixOS..."
sudo /nix/store/*-non-nixos-gpu/bin/non-nixos-gpu-setup

echo ""
echo ">> GPU support activated. Restarting non-nixos-gpu service..."
sudo systemctl restart non-nixos-gpu.service || true

echo ""
echo ">> Done! GUI apps (wezterm, zed, etc.) should now work."
