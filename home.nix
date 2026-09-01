{ pkgs, user, ... }:
{
  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Abdelrahmane FERCHICHI";
    userEmail = "abdel.ferchi38@gmail.com";
  };

  imports = [
    ./modules/packages.nix
    ./modules/shell.nix
    ./modules/aliases.nix
    ./modules/tmux.nix
    ./modules/agents.nix
    ./modules/files.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";

    # Ollama running locally on Taichi.
    OLLAMA_HOST = "http://127.0.0.1:11434";
  };
}
