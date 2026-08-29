{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
in
{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";

  # ============================================================
  # DEVELOPMENT TOOLS
  # ============================================================

  home.packages = with pkgs; [
    # CLI
    ripgrep
    fd
    fzf
    jq
    yq
    tree
    bat
    eza
    btop
    htop
    wget
    curl
    unzip
    zip
    ollama

    # Git
    git
    git-lfs
    gh
    lazygit

    # Editor
    neovim

    # Shell
    starship
    zoxide

    # Python
    python3
    uv
    ruff
    basedpyright

    # JavaScript / TypeScript
    nodejs
    prettier

    # Go
    go
    gopls

    # Rust
    rustc
    cargo
    rustfmt
    rust-analyzer

    # Lua
    lua-language-server
    stylua

    # Shell
    bash-language-server
    shfmt

    # C / C++
    gcc
    cmake
    gnumake
    pkg-config

    # Containers
    docker
    docker-compose
    colima

    # AI agents
    pi-coding-agent
    opencode

    # Fonts
    nerd-fonts.hack
  ];

  # ============================================================
  # ENVIRONMENT
  # ============================================================

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";

    # Ollama runs remotely on the 128 GB Mac via Tailscale.
    OLLAMA_HOST = "http://macpro:11434";
  };

  # ============================================================
  # ZSH
  # ============================================================

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      bindkey '^f' autosuggest-accept

      # Ensure terminal shells, including WezTerm, use remote Ollama.
      export OLLAMA_HOST="http://macpro:11434"
    '';

    shellAliases = {
      ".." = "cd ..";

      # Git
      add = "git add .";
      push = "git push";
      pull = "git pull";
      gs = "git status";
      lg = "lazygit";
      m = "git switch main";

      # Neovim
      v = "nvim";
      vi = "nvim";

      # Files
      ll = "eza -la";
      cat = "bat";

      # AI
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";

      # Remote Ollama on macpro
      ol = "ollama";
      ol-list = "ollama list";
      ol-qwen = "ollama run qwen3.8-flash-next:125b-mlx";
    };
  };

  # ============================================================
  # STARSHIP
  # ============================================================

  programs.starship = {
    enable = true;

    settings = {
      add_newline = false;

      format =
        "$directory$git_branch$git_status$cmd_duration$line_break$character";

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };

      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # ============================================================
  # ZOXIDE
  # ============================================================

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # ============================================================
  # DOTFILES
  # ============================================================

  home.file.".config/wezterm" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/.config/wezterm";
    force = true;
  };

  home.file.".config/nvim" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/.config/nvim";
    force = true;
  };

  home.file.".config/herdr" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/.config/herdr";
    force = true;
  };

  home.file.".claude/settings.json" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/.claude/settings.json";
    force = true;
  };

  # ============================================================
  # PI CODING AGENT
  # ============================================================

  # Only stable, versioned Pi configuration lives in dotfiles.
  # Pi manages its own runtime packages/cache in ~/.pi/agent/npm
  # and ~/.pi/agent/git outside of Home Manager.
  home.file.".pi/agent/settings.json" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/.pi/agent/settings.json";
    force = true;
  };

  home.file.".pi/agent/models.json" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/.pi/agent/models.json";
    force = true;
  };

  # ============================================================
  # SHARED AGENTS
  # ============================================================

  home.file.".claude/CLAUDE.md" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/AGENTS.md";
    force = true;
  };

  home.file.".codex/AGENTS.md" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/AGENTS.md";
    force = true;
  };

  home.file.".config/opencode/AGENTS.md" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/AGENTS.md";
    force = true;
  };

  home.file.".config/opencode/opencode.json" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/.config/opencode/opencode.json";
    force = true;
  };
}