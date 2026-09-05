# dotfiles

Home Manager + Nix configuration that works on any Ubuntu/Linux machine
(x86_64 or aarch64). The flake derives the user name from the running
system, so you don't have to edit anything per machine.

## Prerequisites

The only thing to install first is **Nix**. Then
`bash rebuild.sh` (Quick Start) installs Home Manager and every other
app for you.

### 1. Install Nix

```bash
# Install Nix (single-user install; no root needed)
sh <(curl -L https://nixos.org/nix/install)

# Or use the Determinate Systems installer (multi-user, needs sudo):
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Activate Nix in your current shell so `nix`/`home-manager` work
# (single-user install):
source ~/.nix-profile/etc/profile.d/nix.sh
# (multi-user install):
# source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### 2. Enable flakes

This repo's config is a Nix **flake**, so enable flakes and
`nix-command`. Create `~/.config/nix/nix.conf` (or edit
`/etc/nix/nix.conf` and add `trusted-users = root <your-username>`):

```
experimental-features = nix-command flakes
```

Or export the flags per command:

```bash
export NIX_CONFIG='experimental-features = nix-command flakes'
```

## Quick Start

### 1. Install everything via the dotfiles

Run `bash rebuild.sh` — it **installs all apps for you** (no need to
install anything else first, including Home Manager itself):

```bash
git clone https://github.com/delinocode/dotfiles.git
cd dotfiles
git checkout universal

# This installs every app (Home Manager + all packages.nix packages):
bash rebuild.sh
# Answer the prompt with y to apply
```

When prompted:

```
Apply Home Manager configuration for <your-user>? [y/N] y
```

**What `rebuild.sh` installs** (from `modules/packages.nix`, plus
`home-manager` itself): git, gh, curl, wget, jq, yq, ripgrep, fd, eza,
bat, fzf, zoxide, neovim, tmux, btop, fastfetch, lazygit, ollama,
pi-coding-agent, opencode, wezterm, starship, nerd-fonts.hack,
claude-code.

### 2. Verify installation

```bash
# Re-login (or reconnect SSH) so the new Zsh + apps are on PATH

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
│   ├── packages.nix       # Apps to install (git, neovim, tmux,
│   │                      #   ollama, pi/opencode/claude-code, wezterm, …)
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

This checks the flake, builds **all** apps (without activating), then
prompts to apply. Answer `y` to install everything (Home Manager + all
packages), activate the Home Manager generation, and set Zsh as your login
shell.

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
# (first time only, or use the branch for that machine)
git checkout universal
git reset --hard origin/universal

# Installs all apps again on the new machine:
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

- `pi-tmux-taichi` — Pi via the `taichi-ollama` provider (Ollama host
  `http://taichi:11434`; run `rebuild.sh` to install Pi)
- `pi-tmux-macpro` — Pi via the `macpro-ollama` provider
  (`http://macpro:11434`)
- `pi-tmux-mlx-macpro` — Pi via the `macpro-mlx` provider
  (`http://macpro:11234`)

### Claude Code

- `cc-tmux-taichi` — Claude Code via the `taichi-ollama` provider
  (`http://taichi:11434`)
- `cc-tmux-macpro` — Claude Code via `macpro-ollama` (`http://macpro:11434`)
- `cc-tmux-mlx-macpro` — Claude Code via `macpro-mlx` (`http://macpro:11234`)

### OpenCode

- `oc-tmux-taichi` — OpenCode via the `taichi-ollama` provider
  (`http://taichi:11434`)
- `oc-tmux-macpro` — OpenCode via `macpro-ollama` (`http://macpro:11434`)
- `oc-tmux-mlx-macpro` — OpenCode via `macpro-mlx` (`http://macpro:11234`)

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

Set `home.stateVersion` in `home.nix` to your Ubuntu release's `YY.MM`
(e.g. `"24.04"`).

### "does not provide attribute homeConfigurations.<user>"

Just run `bash rebuild.sh` (it uses `--impure` and passes the flake as a
local path, so it always builds/activates the right user config).

### `home-manager: command not found`

You don't have to install it first — `bash rebuild.sh` installs Home
Manager and all packages via the flake (`home-manager switch --impure`).
If you ran something else that needs `home-manager`, open a fresh shell
after `rebuild.sh` so the new generation is on PATH.

## License

MIT
