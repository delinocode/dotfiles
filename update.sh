#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$DIR"

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Erreur : le dépôt contient des modifications non commités."
  echo "Commit ou stash tes changements avant de mettre à jour les inputs."
  git status --short
  exit 1
fi

echo "==> Mise à jour des inputs Nix"
nix flake update

echo "==> Reconstruction macOS"
"$DIR/rebuild.sh"

if git diff --quiet -- flake.lock; then
  echo "==> Aucun changement dans flake.lock à commit."
  exit 0
fi

echo "==> Changements de flake.lock :"
git diff --stat -- flake.lock

git add flake.lock
git commit -m "Update flake inputs"
git push

echo "==> Mise à jour terminée et envoyée vers origin/main."