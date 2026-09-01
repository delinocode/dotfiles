{ config, dotfiles, ... }:
{
  home.file.".config/wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
    force = true;
  };

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
    force = true;
  };

  home.file.".config/herdr" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
    force = true;
  };

  home.file.".config/opencode/opencode.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/opencode/opencode.json";
    force = true;
  };

  home.file.".config/opencode/AGENTS.md" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
    force = true;
  };

  home.file.".pi/agent/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/settings.json";
    force = true;
  };

  home.file.".pi/agent/models.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/models.json";
    force = true;
  };

  home.file.".claude/settings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";
    force = true;
  };

  home.file.".claude/CLAUDE.md" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
    force = true;
  };

  home.file.".codex/AGENTS.md" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
    force = true;
  };
}
