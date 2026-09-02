# dotfiles

NixOS + Home Manager configuration for multi-machine development.

## Quick Start

### 1. Install Nix

```bash
# Install Nix (multi-user mode)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Activate Nix in current shell
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### 2. Clone the repository

```bash
git clone https://github.com/delinocode/dotfiles.git
cd dotfiles
git checkout taichi-final
```

### 3. Apply the configuration

```bash
# Build and apply Home Manager configuration
bash rebuild.sh
```

When prompted:
```
Apply Home Manager configuration for delai on Taichi? [y/N] y
```

### 4. Verify installation

```bash
# Check git config (should show your name/email)
git config --global user.name
git config --global user.email

# Test aliases
alias pi-tmux-taichi
alias cc-tmux-taichi
alias oc-tmux-taichi
```

## Structure

```
.
├── flake.nix              # Nix flake entry point
├── configuration.nix      # System-wide NixOS configuration
├── home.nix               # Home Manager user configuration
├── modules/               # Modular configurations
│   ├── aliases.nix        # Shell aliases (Pi, Claude Code, OpenCode)
│   ├── agents.nix         # Agent-specific settings
│   ├── packages.nix       # System packages
│   ├── shell.nix          # Shell configuration
│   ├── tmux.nix           # Tmux settings
│   └── files.nix          # File links
├── home/                  # User config files
│   ├── .config/           # Application configs (WezTerm, Neovim, etc.)
│   ├── .pi/               # Pi configuration
│   ├── .claude/           # Claude Code config
│   ├── AGENTS.md          # Agent documentation
│   └── CLAUDE.md          # Claude instructions
├── scripts/               # Utility scripts
│   ├── cc-mlx-picker.sh   # MLX model picker for Claude Code
│   └── zed-models.py      # Zed editor models config
├── tests/                 # Test scripts
├── rebuild.sh             # Build and apply configuration
└── update.sh              # Update Nix flake inputs
```

## Usage

### Rebuild configuration

```bash
cd ~/dotfiles
bash rebuild.sh
```

### Update flake inputs

```bash
cd ~/dotfiles
bash update.sh
```

### Git workflow

```bash
# Make changes
git add -A
git commit -m "Description of changes"
git push origin taichi-final

# On another machine, pull and apply
git fetch origin taichi-final
git reset --hard origin/taichi-final
bash rebuild.sh
```

## Machines

- `taichi` — Primary development machine (Ubuntu + Nix)
- `macpro` — Remote build/ML host
- `calm` — Secondary machine

## Aliases

### Pi (AI assistant)

- `pi-tmux-taichi` — Pi with local Ollama on Taichi
- `pi-tmux-macpro` — Pi with remote Ollama on MacPro
- `pi-tmux-mlx-macpro` — Pi with MLX on MacPro

### Claude Code

- `cc-tmux-taichi` — Claude Code with local Ollama
- `cc-tmux-macpro` — Claude Code with remote Ollama
- `cc-tmux-mlx-macpro` — Claude Code with MLX

### OpenCode

- `oc-tmux-taichi` — OpenCode with local Ollama
- `oc-tmux-macpro` — OpenCode with remote Ollama
- `oc-tmux-mlx-macpro` — OpenCode with MLX

### Tmux shortcuts

- `tm <session>` — Attach to tmux session (e.g., `tm pi-taichi`)
- `Ctrl+b, d` — Detach from tmux

## Troubleshooting

### Git authentication

If `git push` asks for password, use a GitHub token:
https://github.com/settings/tokens (scope `repo`)

Or set up SSH:
```bash
ssh-keygen -t ed25519 -C "your@email.com"
# Add public key to https://github.com/settings/keys
git remote set-url origin git@github.com:delinocode/dotfiles.git
```

### Nix channel issues

```bash
nix-channel --update
```

### Home Manager state version mismatch

Update `home.stateVersion` in `home.nix` to match your NixOS version.

## License

MIT
