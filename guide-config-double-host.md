# Guide — Config Nix double-host (MacBook Air + taichi/Ubuntu)

Ce dépôt configure maintenant **deux machines** avec un seul `flake.nix` :

| Hôte flake | Machine | User | Moteur |
|---|---|---|---|
| `#mac` | MacBook Air | `delino` | nix-darwin + Home Manager |
| `#taichi` | taichi (Ubuntu) | `delai` | Home Manager standalone |

Les deux machines sont sur ton **Tailscale**, donc les alias `*-macpro` / `*-taichi` marchent dans les deux sens sans tunnel SSH (sauf les alias `*-tunnel-*` qui restent comme secours).

---

## 1. Premier déploiement

### MacBook Air (comme avant)

```bash
./bootstrap.sh      # Determinate Nix → ~/.dotfiles → user 'delino' → darwin-rebuild
./rebuild.sh        # ou « darwin-rebuild switch --flake ~/.dotfiles#mac »
```

### taichi (Ubuntu)

```bash
./bootstrap-taichi.sh   # Nix multi-user → ~/.dotfiles → user 'delai' → premier home-manager switch → home-manager sur PATH
home-manager switch --flake ~/.dotfiles#taichi   # ensuite, à chaque modif
# ou simplement :
./rebuild.sh            # détecte Linux et fait la même chose que la ligne ci-dessus
```

> Si `home-manager` n'est pas encore sur le PATH après le bootstrap, ouvre un nouveau terminal (le profil Nix ajoute `~/.nix-profile/bin` au PATH), ou relance `./bootstrap-taichi.sh` — l'étape 5 l'installe.

### Changer le hostname d'un hôte ?

Modifie la ligne `user =` / `taichiUser =` correspondante dans `flake.nix` **et** le label après `#` dans `bootstrap.sh` / `bootstrap-taichi.sh` / `rebuild.sh`. Relance le script concerné.

---

## 2. Config partagée vs spécifique

### `home.nix` = la config user commune (les deux hosts)

`home.nix` est importé dans les deux `outputs`. Ce qui est **conditionné par plateforme** à l'intérieur :

| Morceau | MacBook Air | taichi |
|---|
| `home.homeDirectory` | `/Users/delino` | `/home/delai` |
| `colima` (packages) | installé | non installé |
| `nodePackages."@anthropic-ai/claude-code"` | non (cask `claude-code`) | installé |
| alias `ollama launch` / `launchctl` / `open -a Ollama` | présents | supprimés |
| alias `pi-omlx` / `pi-tmux-omlx` / tunnel `11436` | présents (Ollama local Air) | supprimés |

Tout le reste (`ripgrep`, `fd`, `nvim`, zsh, starship, zoxide, providers `pi`/`opencode`, symlink `~/.config/{wezterm,nvim,herdr,opencode…}`, `cc-mlx-picker`) est **identique** sur les deux machines.

### `configuration.nix` = système macOS uniquement

`system.defaults` (Dock, Finder, trackpad), `nix-homebrew`, `homebrew.brews`/`casks` → n'existe que pour `#mac`.
Sur taichi, **il n'y a pas de fichier équivalent** : les tunings système Ubuntu ne sont pas gérés par Nix ici.

---

## 3. Ajouter une appli sur taichi (et/ou sur le Mac)

Règle d'or : **tout se déclare dans `home.nix`**, jamais installé « à la main ». Sinon tu perds la reproductibilité — même logique que le `cleanup = "zap"` Homebrew sur Mac.

### Cas A — le paquet est dans `nixpkgs`

```nix
# home.nix, dans home.packages = with pkgs;
  someLinuxOnlyTool   # ou n'importe quel nom trouvé sur search.nixos.org
```

Puis :

```bash
# sur la machine visée
./rebuild.sh
```

Cas particulier **Claude Code sur taichi** : c'est déjà déclaré (`nodePackages."@anthropic-ai/claude-code"`). Les alias `cc-macpro` / `cc-taichi` l'utilisent avec `ANTHROPIC_BASE_URL=…`.

### Cas B — pas de paquet Nix (ex. `herdr` sur Mac ; une app Linux équivalente n'existerait pas non plus dans nixpkgs)

- Sur **Mac** : ajoute le nom au `brews` ou `casks` de `configuration.nix`, puis `./rebuild.sh` (`cleanup = "zap"` supprimera tout ce qui n'est pas listé — relis l'AVERTISSEMENT dans `AGENTS.md`).
- Sur **taichi** : Nix ne peut pas l'installer. Installe le binaire toi-même (`apt`, npm, AppImage…), mais laisse la **config** dans `home/…` et le symlink `home.file` dans `home.nix` — l'appli lira la config partagée dès que le binaire est là.

### Vérifier sans casser la machine

```bash
nix flake check --no-build                    # les deux hosts
nix build .#darwinConfigurations.mac.system --dry-run   # Mac
nix build .#homeConfigurations.taichi.activationPackage --dry-run  # taichi
```

---

## 4. Travailler sur taichi à distance depuis le MacBook Air

Deux modes, selon que tu es déjà dans le Tailscale ou non :

### Mode 1 — Tailscale actif sur les deux bouts

```bash
# depuis le Mac
ssh delai@taichi
```

Sur taichi, une fois le repo cloné :

```bash
# exemple : ajouter ripgrep à taichi
nano home.nix          # → home.packages += [ ripgrep ]
./rebuild.sh           # host taichi = home-manager switch --flake ~/.dotfiles#taichi
```

Les alias LLM (`ol-macpro`, `cc-macpro`, `pi-mlx-macpro`…) marchent depuis taichi car `macpro` se résout via Tailscale ; `secrets/env` doit être copié à la main sur taichi (gitignoré).

### Mode 2 — Tailscale en panne

```bash
# depuis le Mac
ol-tunnels      # tunnel 12435 → Ollama macpro ; 12436 → Ollama taichi
claude-macpro   # Claude Desktop sur le Mac via le tunnel (macOS only)

# depuis taichi (si tu y as accès autrement)
./rebuild.sh    # reconstruit taichi ; pas besoin du tunnel pour les aliases
```

### tmux = agents persistants

```bash
tnew claude-macpro
# Ctrl+b d → détacher ; l'agent continue

tm claude-macpro
# depuis un autre terminal, s'y rattacher

tkill claude-macpro
# tout stopper
```

---

## 5. Résumé des changements de la branche `ubuntu`

- `flake.nix` : host `#taichi` (home-manager standalone, `x86_64-linux`, user `delai`) ; plus `macUser`/`taichiUser` séparés.
- `home.nix` : plateforme-conditionnel (`homeDirectory`, paquets, alias `ollama launch`/`launchctl`/oMLX réservés au Mac).
- `bootstrap-taichi.sh` : bootstrap Ubuntu, comme `bootstrap.sh` sur Mac.
- `rebuild.sh` : **détecte le système** — Mac → `darwin-rebuild …#mac`, taichi → `home-manager …#taichi`.
- `opencode.json` : provider `macpro-mlx` ajouté → `oc-mlx-macpro` / `oc-tmux-mlx-macpro` marchent depuis taichi.
- Docs : `raccourcis-et-alias.md` (+§9 taichi), `guide-llm-distant-macbook-air.md` (décrit toujours le côté Mac), **ce fichier**.

### Avant de déployer sur taichi

1. Copier **tout** le repo sur taichi (y compris `home/` et les symlinkés) — pas de `git clone` : copie les fichiers ou laisse le symlink `~/.dotfiles → repo`.
2. Copier `secrets/env` sur taichi (jamais commité ; sans lui, `pi-nvidia`/NVIDIA et les providers qui ont besoin d'une clé ne marcheront pas).
3. `nix flake lock --update-input nixpkgs-linux` sur **une** des machines, pour que `flake.lock` enregistre la nouvelle input `nixpkgs-linux` (sinon `#taichi` ne build pas).
4. Lancer `./bootstrap-taichi.sh` (puis `./rebuild.sh` dans un nouveau terminal).
