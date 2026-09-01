# Dotfiles for Taichi

This repository manages the **Home Manager** configuration for the `delai` user on Taichi. System-wide NixOS configuration remains under `/etc/nixos`; this repo does not run `nixos-rebuild`.

## First setup

```bash
git clone --branch taichi-final https://github.com/delinocode/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash rebuild.sh
```

The script checks the flake, builds the Home Manager generation, asks before activation, activates it, then configures Zsh as the login shell. The first time it needs elevated permissions, it will prompt for your `sudo` password to update `/etc/shells` and run `chsh`.

After the first successful run, disconnect and reconnect SSH (or log out and back in) for Zsh to become the login shell.

## Updating configuration

After changing files in this repository:

```bash
cd ~/dotfiles
bash rebuild.sh
```

Run scripts using `bash script-name.sh`; no manual `chmod` is required.

## Manual Zsh setup

If needed, rerun only the login-shell setup:

```bash
cd ~/dotfiles
bash scripts/set-login-shell-zsh.sh
```
