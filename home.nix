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

    # Default Ollama server for your shell and existing applications.
    # This remains your direct Tailscale connection to macpro.
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

      # Default Ollama server: MacBook Pro 128 GB via Tailscale.
      # This keeps your existing application behavior unchanged.
      export OLLAMA_HOST="http://macpro:11434"

      # API keys are local, outside the Nix store and ignored by Git.
      # Expected file: ~/dotfiles/secrets/env
      if [ -f "$HOME/dotfiles/secrets/env" ]; then
        source "$HOME/dotfiles/secrets/env"
      fi
    '';

    shellAliases = {
      # Navigation
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
      # DIRECT OLLAMA SERVERS VIA TAILSCALE
      #
      # These do not require SSH tunnels and keep your workflow intact.
      # ============================================================

      # Default Ollama server: macpro, inherited from OLLAMA_HOST.
      ol = "ollama";
      ol-list = "ollama list";

      # macpro: Apple Silicon / 128 GB (DIRECT)
      ol-macpro = ''OLLAMA_HOST="http://macpro:11434" ollama'';
      cc-macpro = ''OLLAMA_HOST="http://macpro:11434" ollama launch claude'';
      co-macpro = ''OLLAMA_HOST="http://macpro:11434" ollama launch opencode'';

      # Taichi: Ubuntu / 2× RTX 3090 (DIRECT)
      ol-taichi = ''OLLAMA_HOST="http://taichi:11434" ollama'';
      cc-taichi = ''OLLAMA_HOST="http://taichi:11434" ollama launch claude'';
      co-taichi = ''OLLAMA_HOST="http://taichi:11434" ollama launch opencode'';

      # ============================================================
      # CLAUDE DESKTOP VIA OLLAMA + SSH TUNNELS
      #
      # 127.0.0.1:11434 -> local Ollama app/models
      # 127.0.0.1:12435 -> macpro:11434 (SSH user: maclino)
      # 127.0.0.1:11436 -> taichi:11434 (SSH user: delai)
      #
      # These do not alter global OLLAMA_HOST or your existing app.
      # ============================================================

      # Start both remote Ollama tunnels in the background.
      #
      # -f = background after authentication
      # -N = tunnel only, no interactive shell
      # -L = local address:port -> remote host:port
      ol-tunnels = ''
        ssh -fN -L 127.0.0.1:12435:localhost:11434 maclino@macpro
        ssh -fN -L 127.0.0.1:11436:localhost:11434 delai@taichi
      '';

      # Stop only these two exact SSH tunnels.
      ol-stop-tunnels = ''
        pkill -f "ssh -fN -L 127.0.0.1:12435:localhost:11434 maclino@macpro" || true
        pkill -f "ssh -fN -L 127.0.0.1:11436:localhost:11434 delai@taichi" || true
      '';

      # Inspect models from each source.
      ol-local = ''OLLAMA_HOST="http://127.0.0.1:11434" ollama'';
      ol-tunnel-macpro = ''OLLAMA_HOST="http://127.0.0.1:12435" ollama'';
      ol-tunnel-taichi = ''OLLAMA_HOST="http://127.0.0.1:11436" ollama'';

      # Claude Desktop -> models installed locally on this Mac.
      claude-local = ''
        launchctl setenv OLLAMA_HOST "http://127.0.0.1:11434"
        killall Claude 2>/dev/null || true
        open -a Claude
      '';

      # Claude Desktop -> macpro models, through the macpro SSH tunnel.
      claude-macpro = ''
        launchctl setenv OLLAMA_HOST "http://127.0.0.1:12435"
        killall Claude 2>/dev/null || true
        open -a Claude
      '';

      # Claude Desktop -> Taichi models, through the Taichi SSH tunnel.
      claude-taichi = ''
        launchctl setenv OLLAMA_HOST "http://127.0.0.1:11436"
        killall Claude 2>/dev/null || true
        open -a Claude
      '';

      # ============================================================
      # NVIDIA BUILD / NIM VIA PI
      # ============================================================

      # Choose a model interactively in Pi with /model or Ctrl+L.
      pi-nvidia = ''pi --api-key "$NVIDIA_API_KEY"'';

      # Explicit NVIDIA cloud model shortcuts.
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