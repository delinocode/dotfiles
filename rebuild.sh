#!/usr/bin/env bash
# Rebuild the Home Manager environment for the current user.
# Run with: bash rebuild.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
USER_NAME="$(id -un)"
# Pass the flake as an absolute file path so `builtins.getEnv` in flake.nix
# resolves to the runtime user; keep the working tree via --impure.
FLAKE="$SCRIPT_DIR#$USER_NAME"

cd "$SCRIPT_DIR"

# On a fresh machine, home-manager isn't installed yet and isn't in PATH.
# Use `nix run` (not `nix profile install`) so nothing is left in the user
# profile - this is what caused conflicting "home-manager already installed"
# errors on new machines when Home Manager's own module also manages itself.
HM_CMD=(nix run --impure "github:nix-community/home-manager" --)
if command -v home-manager &>/dev/null; then
HM_CMD=(home-manager)
fi

echo "==> Checking flake"
nix flake check --impure

echo
echo "==> Building Home Manager configuration without activation"
"${HM_CMD[@]}" build --impure --flake "$FLAKE"

echo
read -r -p "Apply Home Manager configuration for $USER_NAME? [y/N] " reply
case "$reply" in
[yY]|[yY][eE][sS]) ;;
*)
echo "==> Nothing has been activated."
exit 0
;;
esac

echo "==> Applying Home Manager configuration"
"${HM_CMD[@]}" switch --impure --flake "$FLAKE"

echo "==> Ensuring Zsh is the login shell"
bash "$SCRIPT_DIR/scripts/set-login-shell-zsh.sh"

echo "==> Activating GPU support for non-NixOS..."
GPU_SETUP_SCRIPT=$(find /nix/store -maxdepth 1 -type d -name '*-non-nixos-gpu' 2>/dev/null | head -n1)
if [[ -n "$GPU_SETUP_SCRIPT" ]]; then
GPU_SETUP_BIN="$GPU_SETUP_SCRIPT/bin/non-nixos-gpu-setup"
if [[ -x "$GPU_SETUP_BIN" ]]; then
echo "Found GPU setup script: $GPU_SETUP_BIN"
sudo "$GPU_SETUP_BIN"
sudo systemctl restart non-nixos-gpu.service || true
echo "GPU support activated."
fi
else
echo "No non-nixos-gpu setup script found (may not be needed on this system)."
fi

echo "==> Ensuring Tailscale is up to date and running..."
if command -v tailscale &>/dev/null; then
TAILSCALE_BIN="$(command -v tailscale)"
TAILSCALED_BIN="$(command -v tailscaled || true)"

# Make sure the tailscaled daemon is running (systemd if available, else background it).
if command -v systemctl &>/dev/null && systemctl list-unit-files 2>/dev/null | grep -q '^tailscaled.service'; then
if ! systemctl is-active --quiet tailscaled; then
echo "Starting tailscaled via systemd..."
sudo systemctl enable --now tailscaled
fi
elif [[ -n "$TAILSCALED_BIN" ]] && ! pgrep -x tailscaled &>/dev/null; then
echo "No systemd unit found; starting tailscaled in the background..."
sudo "$TAILSCALED_BIN" --state=/var/lib/tailscale/tailscaled.state &>/tmp/tailscaled.log &
sleep 2
fi

# Bring the node up (idempotent - safe to re-run; only prompts for auth on first run).
if ! "$TAILSCALE_BIN" status &>/dev/null; then
echo "Bringing Tailscale up (first run needs browser auth)..."
sudo "$TAILSCALE_BIN" up || echo "==> Run 'sudo tailscale up' manually to finish authentication."
else
echo "Tailscale is already up: $("$TAILSCALE_BIN" status --self 2>/dev/null | head -n1)"
fi
else
echo "Tailscale binary not found even though it should be installed by Home Manager."
echo "Open a fresh shell so the new PATH picks it up, then re-run rebuild.sh."
fi

echo "==> Done. Reconnect SSH or log out/in to start a new Zsh login session."
