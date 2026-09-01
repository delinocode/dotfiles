# Taichi Dotfiles (Ubuntu-only)

This repository configures a single machine: **Taichi**, running Ubuntu x86_64, user `delai`, managed with standalone Home Manager (no NixOS, no nix-darwin, no macOS, no Homebrew).

It keeps three LLM providers reachable from Taichi:

| Provider | Endpoint | Managed as a host? |
|---|---|---|
| Local Ollama (Taichi) | `http://127.0.0.1:11434/v1` | Yes, this machine |
| Ollama on Mac Pro | `http://macpro:11434/v1` | No, remote via Tailscale |
| MLX Serve on Mac Pro | `http://macpro:11234/v1` | No, remote via Tailscale |

Legacy macOS files (`configuration.nix`, `bootstrap.sh`) remain in the repository for reference only and are **not** used by `flake.nix` on this branch. They are safe to delete once you no longer need the macOS setup.

## Quick setup on a brand-new Taichi machine

Run these steps in order, on Taichi, as user `delai`.

### 1. Clone this branch

```bash
cd /home/delai
git clone --branch taichi-final https://github.com/delinocode/dotfiles.git dotfiles
cd dotfiles
```

If `/home/delai/dotfiles` already exists from a previous attempt, back it up first:

```bash
cd /home/delai
mv dotfiles "dotfiles.backup-$(date +%Y%m%d-%H%M%S)"
git clone --branch taichi-final https://github.com/delinocode/dotfiles.git dotfiles
cd dotfiles
```

### 2. Install Nix (only if `nix --version` fails)

```bash
nix --version || sh <(curl -L https://nixos.org/nix/install) --daemon
```

Log out and back in (or open a new terminal) after installing Nix, then confirm:

```bash
nix --version
```

### 3. Link the repo and lock the flake

```bash
ln -sfn /home/delai/dotfiles /home/delai/.dotfiles
nix flake lock
```

### 4. (Optional) local secrets

If you use API keys (GitHub, NVIDIA, etc.), create a local, git-ignored file:

```bash
cp secrets/env.example secrets/env   # if secrets/env.example exists
chmod 700 secrets
chmod 600 secrets/env
```

Edit `secrets/env` and add your real values. This file is never committed.

### 5. Verify LLM endpoints before building

```bash
curl -fsS http://127.0.0.1:11434/api/tags | jq '.models[].name'
curl -fsS http://macpro:11434/api/tags | jq '.models[].name'
curl -fsS http://macpro:11234/v1/models | jq '.data[].id'
```

If a command fails, that provider is unreachable; fix networking/Tailscale/Ollama before continuing, or simply ignore that provider if you don't plan to use it yet.

### 6. Validate the configuration (no changes applied)

```bash
./scripts/check.sh
```

This must end with:

```text
==> Success. Nothing has been activated.
```

If it fails, fix the reported error before continuing. Do not proceed to step 7.

### 7. Apply the configuration

```bash
./rebuild.sh
```

Answer `y` when asked to confirm. Then reload your shell:

```bash
exec zsh
```

### 8. Confirm everything works

```bash
./scripts/doctor.sh
```

## Everyday commands

### Local Taichi Ollama

```bash
ol-list
ol-ps
ol-qwen
ol-nemotron
gpu
gpu-watch
```

### Remote Mac Pro (Ollama), via Tailscale

```bash
ol-macpro-list
ol-macpro-qwen
oc-macpro
pi-macpro
```

### Remote Mac Pro (MLX Serve), via Tailscale

```bash
mlx-models
oc-mlx-macpro
pi-mlx-macpro
```

### Persistent agents (survive SSH/client disconnects)

```bash
oc-tmux-taichi
oc-tmux-macpro
oc-tmux-mlx-macpro
pi-tmux-taichi
```

Detach without stopping the agent: `Ctrl+b`, then `d`.

List and reattach:

```bash
tmls
tm opencode-taichi
```

## Updating the configuration later

```bash
cd /home/delai/dotfiles
./update.sh      # updates flake.lock only, never commits or pushes automatically
./rebuild.sh      # review, confirm, then apply
```

## Repository layout

```text
dotfiles/
├── flake.nix              # Taichi-only Home Manager entry point
├── home.nix               # imports the modules below
├── modules/
│   ├── packages.nix       # CLI tools, editors, language servers
│   ├── shell.nix          # zsh, starship, zoxide
│   ├── aliases.nix        # Ollama/Mac Pro/MLX aliases, git, nav
│   ├── tmux.nix           # tmux configuration
│   ├── agents.nix         # persistent tmux agent aliases
│   └── files.nix          # symlinks into ~/dotfiles/home/*
├── home/                  # real dotfiles content (nvim, pi, opencode, claude)
├── scripts/
│   ├── check.sh           # validate + build, no activation
│   └── doctor.sh          # diagnostics: Ollama, GPU, Tailscale, tmux
├── rebuild.sh             # check.sh, then ask to apply
├── update.sh              # updates flake.lock, no auto-commit/push
├── bootstrap-taichi.sh    # first-time setup on a fresh machine
└── secrets/               # local-only, git-ignored secrets
```

## Safety notes

- Nothing in this repo runs `git commit` or `git push` automatically.
- `check.sh` never activates anything; only `rebuild.sh`, after your explicit `y`, applies changes.
- Secrets belong in `secrets/env`, which is git-ignored. Never put tokens directly in `.nix` or `.json` files.
