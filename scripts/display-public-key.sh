#!/usr/bin/env bash
# Print the GitHub SSH public key and copy it to the clipboard.
# Run with: bash scripts/display-public-key.sh

set -euo pipefail

KEY_PATH="$HOME/.ssh/id_ed25519_github"

if [[ ! -f "$KEY_PATH.pub" ]]; then
echo "No public key found at $KEY_PATH.pub"
echo "Run 'bash scripts/ssh-key-setup.sh' first to generate one."
exit 1
fi

echo "=== $KEY_PATH.pub ==="
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
