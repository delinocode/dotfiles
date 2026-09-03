{ config, pkgs, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
in
{
  home.file.".config/fastfetch/config.jsonc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/fastfetch/config.jsonc";
    force = true;
  };

  home.file.".config/ghostty/config" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/ghostty/config";
    force = true;
  };

  home.file.".config/opencode/opencode.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/opencode/opencode.json";
    force = true;
  };

  home.file.".pi/agent/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/settings.json";
    force = true;
  };

  home.file.".pi/agent/AGENTS.md" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/AGENTS.md";
    force = true;
  };

  home.file.".claude/CLAUDE.md" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/CLAUDE.md";
    force = true;
  };

  # The template is versioned; Claude/ECC must retain a real writable runtime file.
  home.activation.ensureClaudeSettingsWritable =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      target="$HOME/.claude/settings.json"
      template="${dotfiles}/home/.claude/settings.json"

      mkdir -p "$HOME/.claude"

      if [ -L "$target" ]; then
        resolved="$(readlink -f -- "$target" 2>/dev/null || true)"
        case "$resolved" in
          /nix/store/*)
            rm -f -- "$target"
            cp -- "$template" "$target"
            chmod 600 -- "$target"
            ;;
        esac
      elif [ ! -e "$target" ]; then
        cp -- "$template" "$target"
        chmod 600 -- "$target"
      fi
    '';
}
