#!/usr/bin/env bash
# Generate (or reuse) an SSH key for GitHub, register it, and configure git
# identity to match the delinocode GitHub account.
# Run with: bash scripts/ssh-key-setup.sh

set -euo pipefail

GITHUB_USER="delinocode"
GITHUB_EMAIL="abdel.ferchi38@gmail.com"
KEY_PATH="$HOME/.ssh/id_ed25519_github"

echo "=== SSH key setup for GitHub ($GITHUB_USER) ==="
echo

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [[ -f "$KEY_PATH" ]]; then
echo "==> Key already exists at $KEY_PATH, reusing it."
else
echo "==> Generating new ed25519 key..."
ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f "$KEY_PATH" -N ""
fi
chmod 600 "$KEY_PATH"
chmod 644 "$KEY_PATH.pub"

echo
echo "==> Registering key with ssh-agent..."
eval "$(ssh-agent -s)" >/dev/null
ssh-add "$KEY_PATH" 2>/dev/null || true

# Add/refresh a Host block for github.com in ~/.ssh/config so plain
# `git@github.com` remotes automatically use this key.
SSH_CONFIG="$HOME/.ssh/config"
touch "$SSH_CONFIG"
chmod 600 "$SSH_CONFIG"
if ! grep -q "Host github.com" "$SSH_CONFIG" 2>/dev/null; then
echo "==> Adding github.com entry to $SSH_CONFIG"
{
echo ""
echo "Host github.com"
echo "  HostName github.com"
echo "  User git"
echo "  IdentityFile $KEY_PATH"
echo "  IdentitiesOnly yes"
} >> "$SSH_CONFIG"
else
echo "==> $SSH_CONFIG already has a github.com entry, leaving it as is."
fi

echo
echo "==> Setting git identity to match $GITHUB_USER..."
CURRENT_NAME="$(git config --global user.name || true)"
CURRENT_EMAIL="$(git config --global user.email || true)"

if [[ "$CURRENT_NAME" != "$GITHUB_USER" ]]; then
git config --global user.name "$GITHUB_USER"
echo "  user.name  set to: $GITHUB_USER (was: ${CURRENT_NAME:-unset})"
else
echo "  user.name  already correct: $GITHUB_USER"
fi

if [[ "$CURRENT_EMAIL" != "$GITHUB_EMAIL" ]]; then
git config --global user.email "$GITHUB_EMAIL"
echo "  user.email set to: $GITHUB_EMAIL (was: ${CURRENT_EMAIL:-unset})"
else
echo "  user.email already correct: $GITHUB_EMAIL"
fi

echo
echo "=== Your public key ==="
cat "$KEY_PATH.pub"
echo

if command -v xclip &>/dev/null; then
cat "$KEY_PATH.pub" | xclip -selection clipboard
echo "==> Copied to clipboard (xclip)."
elif command -v xsel &>/dev/null; then
cat "$KEY_PATH.pub" | xsel --clipboard
echo "==> Copied to clipboard (xsel)."
elif command -v wl-copy &>/dev/null; then
cat "$KEY_PATH.pub" | wl-copy
echo "==> Copied to clipboard (wl-copy)."
elif command -v pbcopy &>/dev/null; then
cat "$KEY_PATH.pub" | pbcopy
echo "==> Copied to clipboard (pbcopy)."
else
echo "==> No clipboard tool found (xclip/xsel/wl-copy/pbcopy); copy it manually above."
fi

echo
echo "==> Next step: add this key at https://github.com/settings/keys"
echo "    (or run: gh ssh-key add \"$KEY_PATH.pub\" --title \"$(hostname)\" if gh is authenticated)"
echo
echo "==> Point the dotfiles remote at SSH once the key is added:"
echo "    git remote set-url origin git@github.com:$GITHUB_USER/dotfiles.git"
echo
echo "==> Testing SSH connection to GitHub (safe to ignore failure before the key is added)..."
if ssh -T -o StrictHostKeyChecking=accept-new -o BatchMode=yes git@github.com 2>&1 | grep -q "successfully authenticated"; then
echo "✓ SSH to GitHub works."
else
echo "✗ Not authenticated yet - add the public key above to GitHub, then re-run this script or:"
echo "    ssh -T git@github.com"
fi

echo
echo "=== Done ==="
