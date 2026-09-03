{
  config,
  pkgs,
  user,
  ...
}:

{
  imports = [
    ./modules/shell.nix
    ./modules/aliases.nix
    ./modules/agents.nix
    ./modules/files.nix
    ./modules/tmux.nix
    ./modules/packages.nix
  ];

  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
