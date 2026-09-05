#!/usr/bin/env bash
# Install ECC (https://github.com/affaan-m/ECC) into the dotfiles and wire
# it into Claude Code. Node.js/git/curl come from home.packages, so this
# works on any Ubuntu/Linux host that has Nix installed.
set -euo pipefail

REPO="${DOTFILES:-$HOME/dotfiles}"
ECC="$REPO/ECC"
target="$HOME/.claude"

# 1) Clone ECC into the dotfiles (idempotent).
if [ ! -d "$ECC" ]; then
  git clone https://github.com/affaan-m/ECC.git "$ECC"
fi

# 2) Copy ECC's own Claude files into ~/.claude and keep them writable
#    (activation copies the versioned files; ECC's installer may rewrite
#    hooks/settings, so they must stay real files, not store symlinks).
mkdir -p "$target"
copy_into_claude() {
  local src="$1" name="$2"
  if [ -e "$target/$name" ] || [ -L "$target/$name" ]; then
    rm -f -- "$target/$name"
  fi
  cp -- "$src" "$target/$name"
  chmod 600 -- "$target/$name"
}
copy_into_claude "$REPO/home/CLAUDE.md" "CLAUDE.md"
copy_into_claude "$REPO/home/.claude/settings.json" "settings.json"

# 3) Install the ECC plugin itself (once) with Nix's Node.js.
if command -v node >/dev/null 2>&1; then
  if [ ! -f "$target/plugins/ecc@ecc" ]; then
    ( cd "$REPO" && npx --yes ecc-universal install --guided \
        --harness claude --profile core --no-hooks --yes ) || \
      echo "==> ECC install reported issues; Claude still uses the copied files."
  else
    echo "==> ECC plugin already present; skipping install."
  fi
fi

echo "==> ECC lives in $ECC; Claude config in $target"
echo "    Claude provider: http://taichi:11434/v1 (remote Taichi, not local)."
