# dotfiles

Home Manager + Nix configuration that works on any Ubuntu/Linux machine
(x86_64 or aarch64). The flake derives the user name from the running
system, so you don't have to edit anything per machine.

## Prerequisites

### 1. Install Nix

```bash
# Install Nix (single-user install; no root needed)
sh <(curl -L https://nixos.org/nix/install)

# Or use the Determinate Systems installer (multi-user, needs sudo):
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Install Home Manager

Point Nix at the Home Manager source for your Nixpkgs channel. For
`nixpkgs-unstable` (what this repo uses):

```bash
# Detect your channel from the nixpkgs input (or set it yourself)
NIXPKGS_CHANNEL=unstable

# Install the matching Home Manager
nix-channel --add "https://github.com/nix-community/home-manager/archive/release-${NIXPKGS_CHANNEL}.tar.gz" home-manager
nix-channel --update

# Create your Home Manager environment
home-manager switch
```

### 3. Enable flakes

The configs are flakes, so enable the Nix **flakes** and **nix-command**
experimental features. Create `~/.config/nix/nix.conf` (or edit
`/etc/nix/nix.conf` with `trusted-users = root <your-username>`):

```
experimental-features = nix-command flakes
```

Or export the flags per command instead:

```bash
export NIX_CONFIG='experimental-features = nix-command flakes'
```

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/delinocode/dotfiles.git
cd dotfiles

# Use the universal branch (works on any Ubuntu/Linux box):
git checkout universal
# (or the current machine branch, e.g. `taichi-final`)
```

### 2. Apply the configuration

```bash
# Build and apply Home Manager configuration
bash rebuild.sh
```

When prompted (the name/branch depend on your machine/user):

```
Apply Home Manager configuration for <your-user>? [y/N] y
```

### 3. Verify installation

```bash
# Check git config (should show your name/email)
git config --global user.name
git config --global user.email

# Test aliases
alias pi-tmux-taichi
alias cc-tmux-taichi
alias oc-tmux-taichi

# Check what's installed / running
bash scripts/doctor.sh
```

## Structure

```
.
├── flake.nix              # Nix flake entry point (derives user from $USER)
├── configuration.nix      # System-wide NixOS configuration
├── home.nix               # Home Manager user configuration
├── modules/               # Modular configurations
│   ├── aliases.nix        # Shell aliases (Pi, Claude Code, OpenCode)
│   ├── agents.nix         # Agent-specific settings
│   ├── packages.nix       # System packages
│   ├── shell.nix          # Shell configuration
│   ├── tmux.nix           # Tmux settings
│   └── files.nix          # File links
├── home/                  # Config files symlinked into your home
│   ├── .config/           # App configs: wezterm, nvim, opencode, herdr
│   ├── .pi/               # Pi configuration
│   ├── .claude/           # Claude Code config
│   ├── AGENTS.md          # Agent documentation
│   └── CLAUDE.md          # Claude instructions
├── scripts/               # Utility scripts
│   ├── cc-mlx-picker.sh   # MLX model picker for Claude Code
│   ├── check.sh           # Lint/format checks
│   ├── doctor.sh          # Host/command/GPU health check
│   ├── set-login-shell-zsh.sh  # Set Zsh as login shell
│   └── zed-models.py      # Zed editor models config
├── tests/                 # Test scripts
├── rebuild.sh             # Build and apply configuration (any Linux)
└── update.sh              # Update Nix flake inputs
```

## Usage

### Rebuild configuration

```bash
cd ~/dotfiles
bash rebuild.sh
```

This checks the flake, builds (without activating), then prompts to
apply. Answer `y` to activate the Home Manager generation and set Zsh as
your login shell.

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

# Push your branch
git push origin universal   # or origin taichi-final

# On another machine, pull and apply
git fetch origin
git checkout universal       # first time
git reset --hard origin/universal
bash rebuild.sh
```

## Branches

- `universal` — Portable config; works on any Ubuntu/Linux host (derives
  user name from the system). Recommended starting point.
- `taichi-final` — Taichi-specific config (hardcodes user `delai`,
  `x86_64`). Kept for reference.

## Machines

- `taichi` — Primary development machine (Ubuntu + Nix)
- `macpro` — Remote build/ML host
- `calm` — Secondary machine

The `universal` branch lets you run `bash rebuild.sh` on any Linux box
without editing anything; the provider aliases below still point at the
hosts listed here.

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

### Home Manager shortcuts

- `hm-switch` — Apply config via the current user (`#$USER`)
- `hm-build` — Build config without activating
- `hm-check` — Check flake

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

### "does not provide attribute homeConfigurations.<user>"

Run `bash rebuild.sh` (it now uses `--impure`, which lets the flake see
your actual user). On a different machine the user name is detected
automatically.

### `home-manager: command not found`

Install Home Manager (see Prerequisites → 2) and ensure Nix is active in
your shell (`source ~/.nix-profile/etc/profile.d/nix.sh`).

## License

MIT
