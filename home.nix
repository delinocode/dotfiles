{ config, pkgs, ... }:
{
  # GPU support on non-NixOS (Pop!_OS, Ubuntu, etc.)
  # This wraps all GUI packages (wezterm, zed, etc.) with the host's OpenGL/Vulkan drivers
  targets.genericLinux.enable = true;
  targets.genericLinux.gpu.enable = true;

  # Import all module files
  imports = [
    ./modules/aliases.nix
    ./modules/files.nix
    ./modules/packages.nix
    ./modules/shell.nix
    ./modules/tmux.nix
    ./modules/agents.nix
  ];

  home.username = "delino";
  home.homeDirectory = "/home/delino";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
