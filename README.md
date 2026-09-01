# Dotfiles – NixOS + Home Manager (Taichi)

This repository contains my NixOS and Home Manager configuration for the machine **Taichi**.

## Quick start (first time on a new machine)

1. Clone the repo and enter the directory:

   ```bash
   git clone https://github.com/delinocode/dotfiles.git
   cd dotfiles
   git switch taichi-final
   ```

2. Run the rebuild script:

   ```bash
   bash rebuild.sh
   ```

   This will:
   - Validate the flake
   - Apply the NixOS system configuration
   - Apply the Home Manager configuration
   - Set Zsh as your login shell (asking for `sudo` password if needed)

3. Log out and back in (or reconnect SSH).

You should now be in Zsh with Starship, aliases, and all your dotfiles loaded.

## Structure

- `flake.nix` – main entry point, defines system and Home Manager configs
- `hosts/taichi/` – Taichi-specific NixOS configuration
- `home/dela/` – Home Manager configuration for user `dela`
- `scripts/` – helper scripts (including `set-login-shell-zsh.sh`)
- `rebuild.sh` – one-command rebuild script

## Rebuilding after changes

After editing any Nix files:

```bash
bash rebuild.sh
```

No `chmod` or manual shell setup is required; the rebuild script handles everything.

## Changing the login shell manually (optional)

If you ever need to re-run the shell setup manually:

```bash
bash scripts/set-login-shell-zsh.sh
```

This is safe to run multiple times.
