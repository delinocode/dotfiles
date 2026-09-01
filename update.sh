#!/usr/bin/env bash
# Taichi-only: update flake inputs, verify, but never auto-commit/push.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$DIR"

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Error: the repository has uncommitted changes."
  echo "Commit or stash your changes before updating inputs."
  git status --short
  exit 1
fi

echo "==> Updating Nix inputs"
nix flake update

echo "==> Checking flake"
nix flake check

echo
echo "==> Possible changes:"
git diff --stat -- flake.lock

echo
echo "Inputs are updated, but nothing has been applied."
echo "To apply:   ./rebuild.sh"
echo "To inspect: git diff -- flake.lock"
echo "To commit:  git add flake.lock && git commit -m 'Update flake inputs'"
