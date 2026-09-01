# dotfiles

NixOS + Home Manager configuration for multi-machine development.

## Quick Start

```bash
# Clone and apply configuration
git clone https://github.com/delinocode/dotfiles.git
cd dotfiles
bash rebuild.sh
```

## Structure

- `flake.nix` / `flake.lock` — Nix flake definition
- `configuration.nix` — System-wide NixOS configuration
- `home.nix` — Home Manager user configuration
- `modules/` — Modular Nix configurations (aliases, agents, etc.)
- `home/` — Per-user config files (`.config/`, `.pi/`, `.claude/`)
- `scripts/` — Utility scripts
- `tests/` — Test scripts

## Usage

```bash
# Rebuild system and home configuration
bash rebuild.sh

# Update flake inputs
bash update.sh
```

## Machines

- `taichi` — Primary development machine
- `macpro` — Remote build/ML host
- `calm` — Secondary machine

## Documentation

- `CONTRIBUTING.md` — How to contribute
- `LICENSE` — MIT License
