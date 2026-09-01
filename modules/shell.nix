{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreAllDups = true;
      share = true;
    };

    initContent = ''
      bindkey '^f' autosuggest-accept
      setopt interactivecomments

      export EDITOR="nvim"
      export VISUAL="nvim"
      export PAGER="less"
      export OLLAMA_HOST="http://127.0.0.1:11434"

      # Optional local secrets file. Ignored by Git, never committed.
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
