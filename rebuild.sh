#!/usr/bin/env bash
# Re-applique cette config Nix sur la machine courante.
# - macOS (MacBook Air) : Darwin, hôte "mac", via darwin-rebuild (sudo).
# - Linux/Ubuntu (taichi) : home-manager standalone, hôte "taichi".
# À lancer une fois après ./bootstrap.sh (Mac) ou ./bootstrap-taichi.sh
# (taichi). Sur taichi, home-manager doit déjà être sur le PATH ;
# relance ./bootstrap-taichi.sh sinon (étape 5 l'installe).
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$DIR"

case "$(uname -s)" in
  Darwin)
    echo "==> Darwin : reconstruction via darwin-rebuild (hôte 'mac')"
    # sudo limite PATH à un chemin sécurisé qui inclut /nix/.../bin,
    # d'où le chemin absolu résolu avant l'appel à sudo.
    exec sudo "$(command -v darwin-rebuild)" switch --flake "$DIR#mac"
    ;;
  Linux)
    if command -v home-manager >/dev/null 2>&1; then
      HM_BIN="$(command -v home-manager)"
    elif [ -x "$HOME/.nix-profile/bin/home-manager" ]; then
      # Nouveau shell après bootstrap-taichi.sh : sur PATH plus tard,
      # mais déjà installé dans ton profil.
      HM_BIN="$HOME/.nix-profile/bin/home-manager"
    else
      # Premier run : on l'exécute directement depuis la branche épinglée ;
      # la config appliquée par la suite viendra toujours du verrou
      # de ce dépôt.
      echo "    Installation de home-manager (première fois)…"
      nix run github:nix-community/home-manager/release-26.05#homeManager -- \
        switch --flake "$DIR#taichi"
      nix profile add github:nix-community/home-manager/release-26.05#homeManager
      echo "==> Terminé. Utilise ensuite : home-manager switch --flake ~/.dotfiles#taichi"
      exit 0
    fi
    echo "==> Linux : reconstruction via home-manager (hôte 'taichi')"
    exec "$HM_BIN" switch --flake "$DIR#taichi"
    ;;
  *)
    echo "    Système non pris en charge : $(uname -s)." >&2
    exit 1
    ;;
esac
