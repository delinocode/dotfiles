{ user, ... }:
{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";

  imports = [
    ./modules/agents.nix
    ./modules/aliases.nix
    ./modules/files.nix
    ./modules/packages.nix
    ./modules/shell.nix
    ./modules/tmux.nix
  ];

  # ============================================================
  # ENVIRONMENT
  # ============================================================

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";

    # Default terminal Ollama server: Ollama natif on macpro.
    OLLAMA_HOST = "http://macpro:11434";
  };
}
