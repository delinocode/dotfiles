#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

cd "$DIR"

# Empêche une reconstruction depuis un état Git non sauvegardé.
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Erreur : des changements Git ne sont pas commités."
  echo "Fais d'abord : git add -A && git commit -m \"...\""
  exit 1
fi

exec sudo darwin-rebuild switch --flake "$DIR#mac"