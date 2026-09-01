{ ... }:
{
  programs.zsh.shellAliases = {
    pi-tmux-taichi =
      ''tmux new-session -A -s pi-taichi "pi --provider taichi-ollama"'';
    pi-tmux-macpro =
      ''tmux new-session -A -s pi-macpro "pi --provider macpro-ollama"'';
    pi-tmux-mlx-macpro =
      ''tmux new-session -A -s pi-mlx-macpro "pi --provider macpro-mlx"'';

    oc-tmux-taichi =
      ''tmux new-session -A -s opencode-taichi "opencode -m taichi-ollama/qwen3.8:27b-q8_0"'';
    oc-tmux-nemotron =
      ''tmux new-session -A -s opencode-nemotron "opencode -m taichi-ollama/nemotron-3.5-lightning:30b-a3b"'';
    oc-tmux-macpro =
      ''tmux new-session -A -s opencode-macpro "opencode -m macpro-ollama/qwen3.8-flash-next:125b-mlx"'';
    oc-tmux-mlx-macpro =
      ''tmux new-session -A -s opencode-mlx-macpro "opencode -m macpro-mlx/Qwen3.8-Flash-Next-oQ4e-MTP-128k"'';

    cc-tmux-taichi =
      ''tmux new-session -A -s claude-taichi "ANTHROPIC_API_KEY=ollama ANTHROPIC_BASE_URL=http://127.0.0.1:11434 claude"'';
    cc-tmux-macpro =
      ''tmux new-session -A -s claude-macpro "ANTHROPIC_API_KEY=ollama ANTHROPIC_BASE_URL=http://macpro:11434 claude"'';
    cc-tmux-mlx-macpro =
      ''tmux new-session -A -s claude-mlx-macpro "ANTHROPIC_API_KEY=ollama ANTHROPIC_BASE_URL=http://macpro:11234 claude"'';
  };
}
