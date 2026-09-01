{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules
  ];

  # Basic NixOS configuration
  system.stateVersion = 24.05;

  # Enable home-manager as a NixOS module
  home-manager.users.dela = import ./home.nix;

  # Other system configuration will go here
}
