{ config, lib, ... }:

{
  # Install ECC (https://github.com/affaan-m/ECC) into the dotfiles and
  # wire it into Claude Code: clone the ECC repo into the dotfiles and run
  # its installer with Nix's Node.js, which sets up the ecc@ecc plugin in
  # ~/.claude. The versioned CLAUDE.md + settings.json are copied (real
  # files, not store symlinks) so Claude/ECC retain writable runtime files.
  home.activation.installEcc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    bash "${config.home.homeDirectory}/dotfiles/scripts/setup-ecc.sh"
  '';
}
