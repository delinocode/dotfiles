{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git
    gh
    curl
    wget
    jq
    yq
    ripgrep
    fd
    eza
    bat
    fzf
    zoxide
    neovim
    tmux
    btop
    fastfetch
    lazygit
    ollama
    pi-coding-agent
    opencode
    nerd-fonts.hack
    claude-code
  ];
}
