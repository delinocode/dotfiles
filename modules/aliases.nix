{ ... }:
{
  programs.zsh.shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    home = "cd $HOME";

    ll = "eza -la";
    la = "eza -a";
    lt = "eza --tree --level=2";
    cat = "bat";

    gs = "git status";
    ga = "git add";
    gaa = "git add .";
    gc = "git commit";
    gcm = "git commit -m";
    gp = "git push";
    gl = "git pull";
    lg = "lazygit";
    main = "git switch main";

    v = "nvim";
    vi = "nvim";
    dots = "cd $HOME/dotfiles";

    hm-switch = "home-manager switch --flake $HOME/dotfiles#$USER";
    hm-build = "home-manager build --flake $HOME/dotfiles#$USER";
    hm-check = "nix flake check $HOME/dotfiles";
    hm-generations = "home-manager generations";

    # Endpoint inspection.
    ol = "OLLAMA_HOST=http://taichi:11434 ollama";
    ol-list = "OLLAMA_HOST=http://taichi:11434 ollama list";
    ol-taichi = "OLLAMA_HOST=http://taichi:11434 ollama";
    ol-taichi-list = "OLLAMA_HOST=http://taichi:11434 ollama list";
    ol-macpro = "OLLAMA_HOST=http://macpro:11434 ollama";
    ol-macpro-list = "OLLAMA_HOST=http://macpro:11434 ollama list";
    ol-mlx-macpro = "OLLAMA_HOST=http://macpro:11234 ollama";
    ol-mlx-macpro-list = "curl -fsS http://macpro:11234/v1/models | jq";
    mlx-health = "curl -fsS http://macpro:11234/health | jq";
    mlx-models = "curl -fsS http://macpro:11234/v1/models | jq";

    # Direct model runs on Taichi Ollama.
    ol-qwen = "OLLAMA_HOST=http://taichi:11434 ollama run qwen3.8:27b-q8_0";
    ol-nemotron = "OLLAMA_HOST=http://taichi:11434 ollama run nemotron-3.5-lightning:30b-a3b";
    ollama-status = "systemctl status ollama --no-pager";
    ollama-logs = "journalctl -u ollama -f";
    gpu = "nvidia-smi";
    gpu-watch = "watch -n 1 nvidia-smi";
    tailscale-status = "tailscale status";

    # Pi providers.
    pi-taichi = "pi --provider taichi-ollama";
    pi-macpro = "pi --provider macpro-ollama";
    pi-mlx-macpro = "pi --provider macpro-mlx";

    # Claude Code through the Ollama launcher.
    cc-taichi = "OLLAMA_HOST=http://taichi:11434 ollama launch claude";
    cc-macpro = "OLLAMA_HOST=http://macpro:11434 ollama launch claude";
    cc-mlx-macpro = "OLLAMA_HOST=http://macpro:11234 ollama launch claude";

    # OpenCode through the Ollama launcher.
    oc-taichi = "OLLAMA_HOST=http://taichi:11434 ollama launch opencode";
    oc-macpro = "OLLAMA_HOST=http://macpro:11434 ollama launch opencode";
    oc-mlx-macpro = "OLLAMA_HOST=http://macpro:11234 ollama launch opencode";

    # Persistent tmux sessions: Pi.
    pi-tmux-taichi = "env -u TMUX tmux new-session -A -s pi-taichi 'pi --provider taichi-ollama'";
    pi-tmux-macpro = "env -u TMUX tmux new-session -A -s pi-macpro 'pi --provider macpro-ollama'";
    pi-tmux-mlx-macpro = "env -u TMUX tmux new-session -A -s pi-mlx-macpro 'pi --provider macpro-mlx'";

    # Persistent tmux sessions: Claude Code.
    cc-tmux-taichi = "env -u TMUX tmux new-session -A -s claude-taichi 'OLLAMA_HOST=http://taichi:11434 claude'";
    cc-tmux-macpro = "env -u TMUX tmux new-session -A -s claude-macpro 'OLLAMA_HOST=http://macpro:11434 claude'";
    cc-tmux-mlx-macpro = "env -u TMUX tmux new-session -A -s claude-mlx-macpro 'OLLAMA_HOST=http://macpro:11234 claude'";

    # Persistent tmux sessions: OpenCode.
    oc-tmux-taichi = "env -u TMUX tmux new-session -A -s opencode-taichi 'OLLAMA_HOST=http://taichi:11434 opencode'";
    oc-tmux-macpro = "env -u TMUX tmux new-session -A -s opencode-macpro 'OLLAMA_HOST=http://macpro:11434 opencode'";
    oc-tmux-mlx-macpro = "env -u TMUX tmux new-session -A -s opencode-mlx-macpro 'OLLAMA_HOST=http://macpro:11234 opencode'";

    tnew = "env -u TMUX tmux new-session -A -s";
    tmls = "tmux ls";
    tm = "tmux attach-session -d -t";
    tmwatch = "tmux attach-session -t";
    tkill = "tmux kill-session -t";
    tname = "tmux display-message -p '#S'";
    twindows = "tmux list-windows -a";
    tclients = "tmux list-clients";
  };
}