{ ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      bindkey '^f' autosuggest-accept
      setopt interactivecomments

      # Default terminal Ollama server: Ollama natif on macpro.
      export OLLAMA_HOST="http://macpro:11434"

      # Never export ANTHROPIC_BASE_URL globally.
      # MLX-specific variables are isolated in cc-mlx-picker.

      # API keys are local, outside the Nix store and ignored by Git.
      # Expected file: ~/dotfiles/secrets/env
      if [ -f "$HOME/dotfiles/secrets/env" ]; then
        source "$HOME/dotfiles/secrets/env"
      fi
    '';
  };

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

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
