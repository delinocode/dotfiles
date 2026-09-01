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
    hm-switch = "home-manager switch --flake $HOME/dotfiles#delai";
    hm-build = "home-manager build --flake $HOME/dotfiles#delai";
    hm-check = "nix flake check $HOME/dotfiles";
    hm-generations = "home-manager generations";

    # Local Ollama on Taichi.
    ol = "OLLAMA_HOST=http://127.0.0.1:11434 ollama";
    ol-local = "OLLAMA_HOST=http://127.0.0.1:11434 ollama";
    ol-list = "OLLAMA_HOST=http://127.0.0.1:11434 ollama list";
    ol-ps = "OLLAMA_HOST=http://127.0.0.1:11434 ollama ps";
    ol-qwen = "OLLAMA_HOST=http://127.0.0.1:11434 ollama run qwen3.8:27b-q8_0";
    ol-nemotron = "OLLAMA_HOST=http://127.0.0.1:11434 ollama run nemotron-3.5-lightning:30b-a3b";
    ol-stop-qwen = "OLLAMA_HOST=http://127.0.0.1:11434 ollama stop qwen3.8:27b-q8_0";
    ol-stop-nemotron = "OLLAMA_HOST=http://127.0.0.1:11434 ollama stop nemotron-3.5-lightning:30b-a3b";

    # Remote Ollama on Mac Pro through Tailscale. Provider only, not a Nix host.
    ol-macpro = "OLLAMA_HOST=http://macpro:11434 ollama";
    ol-macpro-list = "OLLAMA_HOST=http://macpro:11434 ollama list";
    ol-macpro-ps = "OLLAMA_HOST=http://macpro:11434 ollama ps";
    ol-macpro-qwen = "OLLAMA_HOST=http://macpro:11434 ollama run qwen3.8-flash-next:125b-mlx";
    ol-macpro-small = "OLLAMA_HOST=http://macpro:11434 ollama run qwen3:0.6b";

    # Remote MLX Serve on Mac Pro through Tailscale.
    mlx-status = "curl -fsS http://macpro:11234/api/tags | jq";
    mlx-models = "curl -fsS http://macpro:11234/v1/models | jq";
    mlx-health = "curl -fsS http://macpro:11234/health || true";

    ollama-status = "systemctl status ollama --no-pager";
    ollama-logs = "journalctl -u ollama -f";
    gpu = "nvidia-smi";
    gpu-watch = "watch -n 1 nvidia-smi";
    tailscale-status = "tailscale status";

    pi-taichi = "pi --provider taichi-ollama";
    pi-macpro = "pi --provider macpro-ollama";
    pi-mlx-macpro = "pi --provider macpro-mlx";

    oc-taichi = "opencode -m taichi-ollama/qwen3.8:27b-q8_0";
    oc-nemotron = "opencode -m taichi-ollama/nemotron-3.5-lightning:30b-a3b";
    oc-macpro = "opencode -m macpro-ollama/qwen3.8-flash-next:125b-mlx";
    oc-mlx-macpro = "opencode -m macpro-mlx/Qwen3.8-Flash-Next-oQ4e-MTP-128k";

    cc-taichi = "ANTHROPIC_API_KEY=ollama ANTHROPIC_BASE_URL=http://127.0.0.1:11434 claude";
    cc-macpro = "ANTHROPIC_API_KEY=ollama ANTHROPIC_BASE_URL=http://macpro:11434 claude";
    cc-mlx-macpro = "ANTHROPIC_API_KEY=ollama ANTHROPIC_BASE_URL=http://macpro:11234 claude";

    tnew = "tmux new-session -A -s";
    tmls = "tmux ls";
    tm = "tmux attach-session -d -t";
    tmwatch = "tmux attach-session -t";
    tkill = "tmux kill-session -t";
    tname = "tmux display-message -p '#S'";
    twindows = "tmux list-windows -a";
    tclients = "tmux list-clients";
  };
}
