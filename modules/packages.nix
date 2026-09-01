{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    bat btop curl eza fastfetch fd fzf htop jq less ripgrep tree unzip wget yq zip zoxide
    starship tmux zsh
    git git-lfs gh lazygit
    neovim
    ollama
    python3 uv ruff basedpyright
    nodejs bun prettier typescript typescript-language-server
    go gopls
    cargo rustc rust-analyzer rustfmt
    lua-language-server stylua
    bash-language-server shellcheck shfmt
    gcc cmake gnumake pkg-config
    docker docker-compose
    pi-coding-agent opencode
    nerd-fonts.hack
  ] ++ [
    nodePackages."@anthropic-ai/claude-code"
  ];
}
