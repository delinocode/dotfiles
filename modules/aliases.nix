# Every Zsh alias, moved verbatim from home.nix.
# Includes the tmux aliases - they stay here, not in modules/tmux.nix.
{ ... }:

{
  programs.zsh.shellAliases = {
    # ============================================================
    # NAVIGATION / GIT / EDITOR / FILES
    # ============================================================

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

    # Generic agents
    cc = "claude --dangerously-skip-permissions";
    oc = "opencode";

    # ============================================================
    # OLLAMA NATIF VIA TAILSCALE
    #
    # macpro:11434 -> Ollama natif sur macpro
    # taichi:11434 -> Ollama natif sur Taichi
    #
    # Aucun modèle n'est forcé.
    # ============================================================

    # Default server, inherited from OLLAMA_HOST.
    ol = "ollama";
    ol-list = "ollama list";

    # Mac Pro — native Ollama.
    ol-macpro = ''OLLAMA_HOST="http://macpro:11434" ollama'';

    cc-macpro = ''OLLAMA_HOST="http://macpro:11434" ollama launch claude'';

    oc-macpro = ''OLLAMA_HOST="http://macpro:11434" ollama launch opencode'';

    # Taichi — native Ollama.
    ol-taichi = ''OLLAMA_HOST="http://taichi:11434" ollama'';

    cc-taichi = ''OLLAMA_HOST="http://taichi:11434" ollama launch claude'';

    oc-taichi = ''OLLAMA_HOST="http://taichi:11434" ollama launch opencode'';

    # Local Ollama on the MacBook Air.
    ol-local = ''OLLAMA_HOST="http://127.0.0.1:11434" ollama'';

    # ============================================================
    # MLX SERVE SUR MACPRO VIA TAILSCALE
    #
    # macpro:11234    -> API Ollama-compatible
    # macpro:11234/v1 -> API OpenAI-compatible
    # macpro:11234    -> API Anthropic-compatible
    #
    # Aucun tunnel SSH requis.
    # ============================================================

    # CLI Ollama connected to MLX Serve.
    ol-mlx-macpro = ''OLLAMA_HOST="http://macpro:11234" ollama'';

    ol-mlx-list = ''OLLAMA_HOST="http://macpro:11234" ollama list'';

    ol-mlx-ps = ''OLLAMA_HOST="http://macpro:11234" ollama ps'';

    # Usage: ol-mlx-run <model-name>
    ol-mlx-run = ''OLLAMA_HOST="http://macpro:11234" ollama run'';

    # Diagnostics MLX Serve.
    mlx-status = "curl -sS http://macpro:11234/api/tags";

    mlx-models = "curl -sS http://macpro:11234/v1/models";

    # Claude Code + MLX Serve interactive picker.
    cc-mlx-macpro = "$HOME/.local/bin/cc-mlx-picker";

    # OpenCode + MLX Serve.
    oc-mlx-macpro = ''OLLAMA_HOST="http://macpro:11234" ollama launch opencode'';

    # ============================================================
    # OLLAMA APP + CLAUDE DESKTOP
    #
    # The aliases below open Ollama, never Claude directly.
    #
    # 127.0.0.1:11434 -> Ollama local
    # 127.0.0.1:12435 -> macpro:11434 via SSH
    # 127.0.0.1:11436 -> taichi:11434 via SSH
    # macpro:11234     -> MLX Serve via Tailscale
    # ============================================================

    # Start SSH tunnels for remote native Ollama servers.
    ol-tunnels = ''
      ssh -fN -L 127.0.0.1:12435:localhost:11434 maclino@macpro
      ssh -fN -L 127.0.0.1:11436:localhost:11434 delai@taichi
    '';

    # Stop only these exact two tunnels.
    ol-stop-tunnels = ''
      pkill -f "ssh -fN -L 127.0.0.1:12435:localhost:11434 maclino@macpro" || true
      pkill -f "ssh -fN -L 127.0.0.1:11436:localhost:11434 delai@taichi" || true
    '';

    # Test remote Ollama through local SSH tunnels.
    ol-tunnel-macpro = ''OLLAMA_HOST="http://127.0.0.1:12435" ollama'';

    ol-tunnel-taichi = ''OLLAMA_HOST="http://127.0.0.1:11436" ollama'';

    # Open Ollama Desktop using local Ollama.
    claude-local = ''
      launchctl setenv OLLAMA_HOST "http://127.0.0.1:11434"
      open -a Ollama
    '';

    # Open Ollama Desktop through Mac Pro SSH tunnel.
    claude-macpro = ''
      launchctl setenv OLLAMA_HOST "http://127.0.0.1:12435"
      open -a Ollama
    '';

    # Open Ollama Desktop through Taichi SSH tunnel.
    claude-taichi = ''
      launchctl setenv OLLAMA_HOST "http://127.0.0.1:11436"
      open -a Ollama
    '';

    # Open Ollama Desktop against MLX Serve.
    claude-mlx-macpro = ''
      launchctl setenv OLLAMA_HOST "http://macpro:11234"
      open -a Ollama
    '';

    # ============================================================
    # PI
    #
    # Providers and models are defined in:
    # ~/.pi/agent/models.json
    #
    # Every backend alias explicitly selects the intended provider.
    # Use /model or Ctrl+L inside Pi to choose its configured model.
    # ============================================================

    # Pi default: defaultProvider/defaultModel in settings.json.
    pi-local = "pi";

    # Pi + Mac Pro native Ollama.
    pi-macpro = "pi --provider macpro-ollama";

    # Pi + Taichi native Ollama.
    pi-taichi = "pi --provider taichi-ollama";

    # Pi + Mac Pro MLX Serve.
    pi-mlx-macpro = "pi --provider macpro-mlx";

    # Pi + local MacBook Air oMLX.
    pi-omlx = "pi --provider macbook-omlx";

    # Pi + NVIDIA cloud. The provider reads $NVIDIA_API_KEY from
    # models.json / the environment loaded by secrets/env.
    pi-nvidia = "pi --provider nvidia";

    # Pi + direct NVIDIA model shortcuts.
    pinvidia = "pi --provider nvidia --model nvidia/nemotron-3-super-120b-a12b";

    pinvidia-ultra = "pi --provider nvidia --model nvidia/nemotron-3-ultra-550b-a55b";

    pideepseek = "pi --provider nvidia --model deepseek-ai/deepseek-v4-pro-0813";

    # ============================================================
    # TMUX — PERSISTENT AGENTS
    #
    # Ctrl+b then d: detach without stopping the agent.
    # `-A` creates the named session if absent, otherwise reconnects.
    # ============================================================

    # Claude Code + native Ollama macpro.
    cc-tmux-macpro = ''tmux new-session -A -s claude-macpro "OLLAMA_HOST=http://macpro:11434 ollama launch claude"'';

    # Claude Code + native Ollama Taichi.
    cc-tmux-taichi = ''tmux new-session -A -s claude-taichi "OLLAMA_HOST=http://taichi:11434 ollama launch claude"'';

    # Claude Code + MLX Serve dynamic picker.
    cc-tmux-mlx-macpro = ''tmux new-session -A -s claude-mlx-macpro "$HOME/.local/bin/cc-mlx-picker"'';

    # OpenCode + native Ollama macpro.
    oc-tmux-macpro = ''tmux new-session -A -s opencode-macpro "OLLAMA_HOST=http://macpro:11434 ollama launch opencode"'';

    # OpenCode + native Ollama Taichi.
    oc-tmux-taichi = ''tmux new-session -A -s opencode-taichi "OLLAMA_HOST=http://taichi:11434 ollama launch opencode"'';

    # OpenCode + MLX Serve.
    oc-tmux-mlx-macpro = ''tmux new-session -A -s opencode-mlx-macpro "OLLAMA_HOST=http://macpro:11234 ollama launch opencode"'';

    # Pi + Mac Pro native Ollama.
    pi-tmux-macpro = ''tmux new-session -A -s pi-macpro "pi --provider macpro-ollama"'';

    # Pi + Taichi native Ollama.
    pi-tmux-taichi = ''tmux new-session -A -s pi-taichi "pi --provider taichi-ollama"'';

    # Pi + Mac Pro MLX Serve.
    pi-tmux-mlx-macpro = ''tmux new-session -A -s pi-mlx-macpro "pi --provider macpro-mlx"'';

    # Pi + local oMLX.
    pi-tmux-omlx = ''tmux new-session -A -s pi-omlx "pi --provider macbook-omlx"'';

    # Pi + NVIDIA cloud.
    pi-tmux-nvidia = ''tmux new-session -A -s pi-nvidia "pi --provider nvidia"'';

    # tmux management.
    tnew = "tmux new-session -A -s";
    tmls = "tmux ls";
    tm = "tmux attach-session -d -t";
    tmwatch = "tmux attach-session -t";
    tkill = "tmux kill-session -t";
    tname = "tmux display-message -p '#S'";
    twindows = "tmux list-windows -a";
    tclients = "tmux list-clients";
    treload = "tmux source-file ~/.tmux.conf";
  };
}
