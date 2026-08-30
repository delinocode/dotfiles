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

    # Default Ollama server: MacBook Pro 128 GB via Tailscale.
    # Use ol-taichi / cc-taichi / co-taichi for Taichi explicitly.
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

      # Default Ollama server: MacBook Pro 128 GB.
      export OLLAMA_HOST="http://macpro:11434"

      # API keys are local, outside the Nix store and ignored by Git.
      # Expected file: ~/dotfiles/secrets/env
      if [ -f "$HOME/dotfiles/secrets/env" ]; then
        source "$HOME/dotfiles/secrets/env"
      fi
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

      # Existing coding agents
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";

      # ============================================================
      # REMOTE OLLAMA SERVERS VIA TAILSCALE
      # These aliases select a SERVER, not a fixed model.
      # ============================================================

      # Default Ollama server: MacBook Pro 128 GB
      ol = "ollama";
      ol-list = "ollama list";

      # MacBook Pro 128 GB server
      ol-macpro = ''OLLAMA_HOST="http://macpro:11434" ollama'';
      cc-macpro = ''OLLAMA_HOST="http://macpro:11434" ollama launch claude'';
      co-macpro = ''OLLAMA_HOST="http://macpro:11434" ollama launch opencode'';

      # Taichi: Ubuntu server with 2x RTX 3090
      ol-taichi = ''OLLAMA_HOST="http://taichi:11434" ollama'';
      cc-taichi = ''OLLAMA_HOST="http://taichi:11434" ollama launch claude'';
      co-taichi = ''OLLAMA_HOST="http://taichi:11434" ollama launch opencode'';

      # ============================================================
      # NVIDIA BUILD / NIM VIA PI
      # Model choice is done interactively inside Pi: /model or Ctrl+L.
      # ============================================================

      pi-nvidia = ''pi --api-key "$NVIDIA_API_KEY"'';

      # Optional shortcuts that explicitly choose a cloud model.
      pinvidia =
        ''pi --model nvidia/nemotron-3-super-120b-a12b --api-key "$NVIDIA_API_KEY"'';

      pinvidia-ultra =
        ''pi --model nvidia/nemotron-3-ultra-550b-a55b --api-key "$NVIDIA_API_KEY"'';

      pideepseek =
        ''pi --model deepseek-ai/deepseek-v4-pro-0813 --api-key "$NVIDIA_API_KEY"'';
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

  # Stable Pi config is versioned in dotfiles.
  # Pi keeps runtime packages/cache in ~/.pi/agent/npm and ~/.pi/agent/git.
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