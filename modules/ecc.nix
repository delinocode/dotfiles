{ config, pkgs, lib, ... }:

{
  # Install ECC (https://github.com/affaan-m/ECC) into the dotfiles and
  # wire it into Claude Code. Node.js/git/curl come from home.packages so
  # this runs on any Ubuntu/Linux host with Nix installed; everything
  # installable stays inside the dotfiles.
  home.activation.installEcc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${lib.makeBinPath (with pkgs; [ git nodejs curl jq ])}:$PATH"
    REPO="${config.home.homeDirectory}/dotfiles"
    ECC="$REPO/ECC"
    target="$HOME/.claude"

    # 1) Clone ECC into the dotfiles (idempotent).
    if [ ! -d "$ECC" ]; then
      git clone https://github.com/affaan-m/ECC.git "$ECC"
    fi

    # 2) Copy ECC's versioned Claude files into ~/.claude and keep them
    #    writable (the ECC installer may rewrite hooks/settings; store
    #    symlinks would be read-only).
    mkdir -p "$target"
    copy_into_claude() {
      if [ -e "$target/$2" ] || [ -L "$target/$2" ]; then
        rm -f -- "$target/$2"
      fi
      cp -- "$REPO/$1" "$target/$2"
      chmod 600 -- "$target/$2"
    }
    copy_into_claude "home/CLAUDE.md" "CLAUDE.md"
    copy_into_claude "home/.claude/settings.json" "settings.json"

    # 3) Install the ECC plugin itself (once) with Nix's Node.js so
    #    Claude Code can load `ecc@ecc` from the marketplace.
    if command -v node >/dev/null 2>&1; then
      if [ ! -d "$target/plugins" ]; then
        ( cd "$REPO" && npx --yes ecc-universal install --guided \
            --harness claude --profile core --no-hooks --yes ) || \
          echo "==> ECC install reported issues; Claude uses the copied files."
      fi
    fi

    echo "==> ECC lives in $ECC; Claude config copied to $target"
  '';
}
