# All packages that home.nix declared, verbatim.
# The two AI-agent packages (pi-coding-agent, opencode) live in
# modules/agents.nix, which owns agent-specific configuration - so
# nothing is lost, every package from home.nix exists exactly once.
{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

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
    tmux

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
    bun

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

    # Fonts
    nerd-fonts.hack
  ];
}
