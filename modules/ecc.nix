{ config, pkgs, lib, ... }:

{
  # Install ECC (https://github.com/affaan-m/ECC) into the dotfiles and
  # wire it into Claude Code, all from the dotfiles:
  #   1. clone the ECC repo into the dotfiles
  #   2. register the ecc@ecc plugin with `ecc-universal setup`
  #      (idempotent; updates an existing install)
  # Node.js comes from home.packages so this works on any Ubuntu/Linux host.
  home.activation.installEcc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${lib.makeBinPath (with pkgs; [ git nodejs ])}:$PATH"
    REPO="${config.home.homeDirectory}/dotfiles"
    ECC="$REPO/ECC"

    # 1) Clone ECC into the dotfiles (idempotent).
    if [ ! -d "$ECC" ]; then
      git clone https://github.com/affaan-m/ECC.git "$ECC"
    fi

    # 2) Register/refresh the ecc@ecc plugin for Claude Code (user scope).
    #    This writes ~/.claude/settings.json (enabledPlugins + marketplace)
    #    and makes Claude load ECC's skills/commands/agents.
    ( cd "$ECC" \u0026\u0026 npx --yes ecc-universal setup \
        --mode claude-plugin --scope user --hooks off --yes )

    echo "==> ECC plugin (ecc@ecc) installed at user scope."
    echo "    Start a new Claude Code session (or /reload-plugins) to load it."
  '';
}
