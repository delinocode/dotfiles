# Dotfile symlinks not covered by the agent module.
# All content moved verbatim from home.nix.
{ config, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
in
{
  home.file.".config/wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
    force = true;
  };

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
    force = true;
  };

  home.file.".config/herdr" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
    force = true;
  };
}
