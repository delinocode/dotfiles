#!/usr/bin/env bash
# Run AFTER `bash rebuild.sh` (rebuild.sh installs Node.js via the dotfiles).
#
# Fixes the error:
#   Error: Managed ECC content at ~/.claude/ecc/install-state.json
#   overlaps the Claude plugin. Remove that managed overlap before setup.
# then installs the ecc@ecc plugin for Claude Code.
set -e

# Make node/npx available (Nix single-user or multi-user install).
if ! command -v node >/dev/null 2>&1; then
  [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ] && . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
command -v node >/dev/null 2>&1 || { echo "node not found: run bash rebuild.sh first"; exit 1; }

# Fix the managed-content overlap error (uninstall removes install-state.json).
npx ecc-universal uninstall || true
# If state is still there, remove it.
[ -f "$HOME/.claude/ecc/install-state.json" ] && rm -rf "$HOME/.claude/ecc"

# Install the ecc@ecc plugin for Claude Code.
npx ecc-universal setup

echo "Done. Restart Claude Code (or /reload-plugins) to load ECC."
