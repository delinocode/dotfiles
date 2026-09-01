{ ... }:
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 100000;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    terminal = "screen-256color";

    extraConfig = ''
      set -g renumber-windows on
      set -g status-position top
      set -g detach-on-destroy off
      set -g allow-rename off

      bind r source-file ~/.tmux.conf \; display-message "tmux config reloaded"
    '';
  };
}
