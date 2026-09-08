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

> Pick **one** installer, not both. Running the single-user script and
> the Determinate installer back-to-back on the same machine leaves two
> separate Nix stores/daemons half-configured and causes confusing
> `command not found` errors. If that already happened, check which one
> "won" with `ls -la /nix/var/nix/profiles/default/etc/profile.d/` — if
> `nix-daemon.sh` is there, source that one and remove the single-user
> lines from your shell rc file.

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

> Do **not** run `nix profile install ...#home-manager` yourself before
> this. `rebuild.sh` automatically falls back to `nix run
> github:nix-community/home-manager` when `home-manager` isn't on PATH
> yet, so it bootstraps itself without leaving anything in your user
> profile. If you already ran `nix profile install` manually and hit an
> "existing package already provides ... home-manager.fish" conflict,
> remove it with `nix profile remove home-manager` and re-run
> `bash rebuild.sh`.

When prompted:

```
Apply Home Manager configuration for <your-user>? [y/N] y
```

**What `rebuild.sh` installs** (from `modules/packages.nix`, plus
`home-manager` itself): git, gh, curl, wget, jq, yq, ripgrep, fd, eza,
bat, fzf, zoxide, neovim, zed-editor, tmux, btop, fastfetch, lazygit,
ollama, pi-coding-agent, opencode, wezterm, starship, nerd-fonts.hack,
claude-code, jupyter.

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

### 3. Enable GPU support (wezterm, zed, and other GUI apps)

On non-NixOS systems (Pop!_OS, Ubuntu, etc.), Nix-built GUI apps can't
see your host's GPU drivers by default. `rebuild.sh` already tries to
activate this automatically, but if `wezterm`/`zed` fail with a
`libEGL.so` / `libvulkan.so` error, run:

```bash
bash scripts/enable-gpu-nix.sh
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
│   ├── .config/           # App configs: wezterm, nvim, opencode, herdr, zed
│   ├── .pi/               # Pi configuration
│   ├── .claude/           # Claude Code config
│   ├── AGENTS.md          # Agent documentation
│   └── CLAUDE.md          # Claude instructions
├── scripts/               # Utility scripts
│   ├── cc-mlx-picker.sh   # MLX model picker for Claude Code
│   ├── check.sh           # Lint/format checks
│   ├── doctor.sh          # Host/command/GPU health check
│   ├── enable-gpu-nix.sh  # Activate GPU drivers for Nix GUI apps
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
packages), activate the Home Manager generation, set Zsh as your login
shell, and enable GPU support for GUI apps.

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

You don't have to install it first — `bash rebuild.sh` now detects this
automatically and runs Home Manager via `nix run
github:nix-community/home-manager` instead of requiring it on PATH. If
you still see this error from a command outside `rebuild.sh`, either
open a fresh shell after `rebuild.sh` finishes (so the new generation's
`home-manager` is on PATH), or run commands through
`nix run --impure github:nix-community/home-manager -- <subcommand>`.

### "An existing package already provides ... home-manager.fish"

This happens if `home-manager` was installed twice: once manually via
`nix profile install ...#home-manager`, and once by Home Manager's own
`programs.home-manager.enable = true` module. Fix it by removing the
manual profile entry and re-running `rebuild.sh` (which now bootstraps
Home Manager via `nix run`, so you never need to `nix profile install`
it yourself):

```bash
nix profile list
nix profile remove home-manager   # or the index number nix profile list shows
bash rebuild.sh
```

### GUI apps (wezterm, zed) fail with `libEGL.so` / `libvulkan.so` errors

This is the classic "Nix package manager on non-NixOS" GPU issue: the
Nix-built binary can't see your distro's GPU drivers. Run:

```bash
bash scripts/enable-gpu-nix.sh
```

`home.nix` already sets `targets.genericLinux.gpu.enable = true;`, which
makes `rebuild.sh` print a one-time
`sudo /nix/store/*-non-nixos-gpu/bin/non-nixos-gpu-setup` command; the
script above runs that for you and restarts the service.

## ECC (Claude Code plugin)

Run **after** `bash rebuild.sh` (the dotfiles install Node.js, which ECC needs):

```bash
cd ~/dotfiles
bash scripts/ecc-setup.sh
```

The script fixes the `Managed ECC content ... overlaps the Claude plugin`
error (removes the old managed state), then runs `npx ecc-universal setup`
to install the `ecc@ecc` plugin. It works on any Linux machine. After it
finishes, restart Claude Code (or run `/reload-plugins`).

## License

MIT
