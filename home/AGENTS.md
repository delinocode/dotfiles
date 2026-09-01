# Taichi Agent Instructions

You are working on Taichi, an Ubuntu x86_64 machine.

## Safety

- Do not reveal tokens, passwords, private keys, or secret files.
- Do not use `rm -rf`, `git reset --hard`, or `git clean -fd` without explicit approval.
- Do not overwrite configuration files without creating a backup.
- Do not commit or push Git changes unless explicitly requested.
- Do not run Home Manager activation without approval.

## Nix and Home Manager

Repository: `/home/delai/dotfiles`
User: `delai`

Validate before activation:

```bash
cd /home/delai/dotfiles
nix flake check
home-manager build --flake .#delai
```

Apply only after approval:

```bash
home-manager switch --flake .#delai
```

## Ollama on Taichi

Local endpoint: `http://127.0.0.1:11434`

Expected local models:

- `qwen3.8:27b-q8_0`
- `nemotron-3.5-lightning:30b-a3b`

## Remote providers (Tailscale)

Mac Pro Ollama: `http://macpro:11434/v1`

Mac Pro MLX Serve: `http://macpro:11234/v1`

These are remote providers only. They are not hosts managed by this Taichi configuration.

## Persistent agents

Use tmux for tasks that must survive disconnects.

```bash
oc-tmux-taichi
oc-tmux-macpro
oc-tmux-mlx-macpro
pi-tmux-taichi
```

Detach with `Ctrl+b`, then `d`. List with `tmls`; reattach with `tm <session-name>`.
