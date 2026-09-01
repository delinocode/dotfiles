# Référence complète — Zsh, agents, tmux, WezTerm, Neovim, macOS et Ubuntu (taichi)

## Sommaire

- [1. Alias Zsh](#1-alias-zsh)
  - [1.1 Navigation](#11-navigation)
  - [1.2 Git](#12-git)
  - [1.3 Éditeur](#13- éditeur)
  - [1.4 Fichiers](#14-fichiers)
  - [1.5 Ollama — serveurs directs via Tailscale](#15-ollama--serveurs-directs-via-tailscale)
  - [1.5.1 MLX Serve sur macpro](#151-mlx-serve-sur-macpro)
  - [1.6 Claude Desktop via Ollama + tunnels SSH + MLX Serve](#16-claude-desktop-via-ollama--tunnels-ssh--mlx-serve)
  - [1.7 NVIDIA Build / NIM via Pi](#17-nvidia-build--nim-via-pi)
- [2. Agents sans tmux](#2-agents-sans-tmux)
- [3. Agents avec tmux](#3-agents-avec-tmux)
  - [3.1 Lancer un agent persistant](#31-lancer-un-agent-persistant)
  - [3.2 G gérer les sessions tmux](#32-g rer-les-sessions-tmux)
- [4. Raccourcis clavier tmux](#4-raccourcis-clavier-tmux)
- [5. Raccourcis clavier WezTerm](#5-raccourcis-clavier-wezterm)
- [6. Raccourcis clavier Neovim](#6-raccourcis-clavier-neovim)
- [7. Raccourcis clavier macOS](#7-raccourcis-clavier-macos)
- [8. Routine rapide](#8-routine-rapide)
- [9. Alias sur taichi (Ubuntu)](#9-alias-sur-taichi-ubuntu)

---

## 1. Alias Zsh

[↑ Sommaire](#sommaire)

### 1.1 Navigation

| Alias | Commande | Description |
|---|---|---|
| `..` | `cd ..` | Remonte d'un niveau dans l'arborescence. |

### 1.2 Git

| Alias | Commande | Description |
|---|---|---|
| `add` | `git add .` | Ajoute tous les fichiers modifi s au staging. |
| `push` | `git push` | Pousse les commits vers le remote. |
| `pull` | `git pull` | Tire les changements depuis le remote. |
| `gs` | `git status` | Affiche l' tat du d p t Git. |
| `lg` | `lazygit` | Ouvre l'interface Lazygit. |
| `m` | `git switch main` | Bascule sur la branche `main`. |

### 1.3 diteur

| Alias | Commande | Description |
|---|---|---|
| `v` | `nvim` | Ouvre Neovim. |
| `vi` | `nvim` | Ouvre Neovim. |

### 1.4 Fichiers

| Alias | Commande | Description |
|---|---|---|
| `ll` | `eza -la` | Liste les fichiers en d tail. |
| `cat` | `bat` | Affiche un fichier avec coloration syntaxique. |

### 1.5 Ollama — serveurs directs via Tailscale

Ces commandes ne n cessitent pas de tunnel SSH et gardent ton workflow intact.

| Alias | Commande | Description |
|---|---|---|
| `ol` | `ollama` | Serveur Ollama par d faut, h rit  de `OLLAMA_HOST` (macpro). |
| `ol-list` | `ollama list` | Liste les mod les du serveur par d faut. |
| `ol-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama` | macpro — Apple Silicon / 128 Go de RAM, connexion directe. |
| `cc-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama launch claude` | Lance Claude via macpro, connexion directe. |
| `oc-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama launch opencode` | Lance OpenCode via macpro, connexion directe. |
| `ol-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama` | Taichi — Ubuntu / 2×³ RTX 3090, connexion directe. |
| `cc-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama launch claude` | Lance Claude via Taichi, connexion directe. |
| `oc-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama launch opencode` | Lance OpenCode via Taichi, connexion directe. |

#### G rer les mod les sur Taichi

```bash
ol-taichi list                     # Mod les install s sur Taichi
ol-taichi pull <nom-du-mod le>     # T l charger un mod le sur Taichi
ol-taichi run <nom-du-mod le>      # Ex cuter un mod le sur Taichi
ol-taichi rm <nom-du-mod le>       # Supprimer un mod le de Taichi
ol-taichi ps                       # Mod les actuellement actifs
```

### 1.5.1 MLX Serve sur macpro

MLX Serve est un second serveur sur macpro, s par  d'Ollama natif. Il est accessible directement via Tailscale / MagicDNS  `http://macpro:11234` et pr sente une API compatible Ollama.

- Ollama natif sur macpro : `http://macpro:11434`
- MLX Serve sur macpro : `http://macpro:11234`
- Aucun tunnel SSH n'est n cessaire pour MLX Serve.

| Alias | Commande | Description |
|---|---|---|
| `ol-mlx-macpro` | `OLLAMA_HOST="http://macpro:11234" ollama` | Utilise MLX Serve sur macpro. |
| `cc-mlx-macpro` | `OLLAMA_HOST="http://macpro:11234" ollama launch claude` | Lance Claude Code avec MLX Serve sur macpro. |
| `oc-mlx-macpro` | `OLLAMA_HOST="http://macpro:11234" ollama launch opencode` | Lance OpenCode avec MLX Serve sur macpro. |

#### Mod les MLX Serve

```bash
ol-mlx-macpro list                     # Liste les mod les servis par MLX Serve
ol-mlx-macpro run <nom-du-mod le>      # Lance un mod le dans le terminal
ol-mlx-macpro ps                       # Affiche les mod les actifs
```

Mod les actuellement visibles via MLX Serve :

```text
ddalcu/Qwen3.8-Flash-Next-MLX-Serve-4bit:latest
e9c67b08899964be5fdd069bb1b4bc8907fe68f5:latest
Qwen3.8-Flash-Next-oQ4e-MTP-128k:latest
```

Exemple de test :

```bash
ol-mlx-macpro run ddalcu/Qwen3.8-Flash-Next-MLX-Serve-4bit:latest
```

#### Sessions tmux avec MLX Serve

| Alias | Commande | Description |
|---|---|---|
| `cc-tmux-mlx-macpro` | `tmux new-session -A -s claude-mlx-macpro "OLLAMA_HOST=http://macpro:11234 ollama launch claude"` | Claude Code et MLX Serve dans une session tmux persistante. |
| `oc-tmux-mlx-macpro` | `tmux new-session -A -s opencode-mlx-macpro "OLLAMA_HOST=http://macpro:11234 ollama launch opencode"` | OpenCode et MLX Serve dans une session tmux persistante. |

Ces sessions restent actives apr s avoir ferm  WezTerm ou d connect  ton Samsung. D tache une session avec `Ctrl+b`, puis `d`.

### 1.6 Claude Desktop via Ollama + tunnels SSH + MLX Serve

Mapping des ports :

- `127.0.0.1:11434` → Ollama local, app/mod les sur ce Mac
- `127.0.0.1:12435` → `macpro:11434`, utilisateur SSH `maclino`
- `127.0.0.1:11436` → `taichi:11434`, utilisateur SSH `delai`
- `macpro:11234` → MLX Serve sur macpro (direct Tailscale)

Ces alias ne modifient pas `OLLAMA_HOST` global ni ton application existante.

| Alias | Commande | Description |
|---|---|---|
| `ol-tunnels` | `ssh -fN -L 127.0.0.1:12435:localhost:11434 maclino@macpro` puis `ssh -fN -L 127.0.0.1:11436:localhost:11434 delai@taichi` | D marre les deux tunnels Ollama distants en arri re-plan. |
| `ol-stop-tunnels` | Arr te les deux tunnels SSH d finis ci-dessus. | Arr te uniquement les tunnels Ollama macpro et Taichi. |
| `ol-local` | `OLLAMA_HOST="http://127.0.0.1:11434" ollama` | Inspecte les mod les install s localement. |
| `ol-tunnel-macpro` | `OLLAMA_HOST="http://127.0.0.1:12435" ollama` | Inspecte les mod les de macpro via le tunnel. |
| `ol-tunnel-taichi` | `OLLAMA_HOST="http://127.0.0.1:11436" ollama` | Inspecte les mod les de Taichi via le tunnel. |
| `claude-local` | D finit `OLLAMA_HOST` sur `127.0.0.1:11434`, tue puis relance Claude Desktop. | Claude Desktop → mod les install s localement sur ce Mac. |
| `claude-macpro` | D finit `OLLAMA_HOST` sur `127.0.0.1:12435`, tue puis relance Claude Desktop. | Claude Desktop → mod les macpro, via le tunnel SSH macpro. |
| `claude-taichi` | D finit `OLLAMA_HOST` sur `127.0.0.1:11436`, tue puis relance Claude Desktop. | Claude Desktop → mod les Taichi, via le tunnel SSH Taichi. |
| `claude-mlx-macpro` | D finit `OLLAMA_HOST` sur `http://macpro:11234`, tue puis relance Claude Desktop. | Claude Desktop → MLX Serve sur macpro, via Tailscale. |

### 1.7 NVIDIA Build / NIM via Pi

Choix du mod le possible dans Pi avec `/model` ou `Ctrl+L`.

| Alias | Commande | Description |
|---|---|---|
| `pi-nvidia` | `pi --api-key "$NVIDIA_API_KEY"` | Lance Pi avec la cl  API NVIDIA, choix de mod le interactif. |
| `pinvidia` | `pi --model nvidia/nemotron-3-super-120b-a12b --api-key "$NVIDIA_API_KEY"` | Raccourci explicite vers Nemotron 3 Super 120B-A12B. |
| `pinvidia-ultra` | `pi --model nvidia/nemotron-3-ultra-550b-a55b --api-key "$NVIDIA_API_KEY"` | Raccourci explicite vers Nemotron 3 Ultra 550B-A55B. |
| `pideepseek` | `pi --model deepseek-ai/deepseek-v4-pro-0813 --api-key "$NVIDIA_API_KEY"` | Raccourci explicite vers DeepSeek V4 Pro (0813). |

---

## 2. Agents sans tmux

[↑ Sommaire](#sommaire)

Ces alias lancent l'agent directement dans le terminal courant, sans le passer par tmux. Si tu fermes le terminal, l'onglet WezTerm ou la connexion SSH, l'agent s'arr te.

| Alias | Commande | Description |
|---|---|---|
| `cc` | `claude --dangerously-skip-permissions` | Agent de code existant, lanc  directement. |
| `oc` | `opencode` | Agent de code existant, lanc  directement. |
| `cc-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama launch claude` | Claude, backend Ollama natif macpro, direct dans le terminal. |
| `oc-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama launch opencode` | OpenCode, backend Ollama natif macpro, direct dans le terminal. |
| `cc-mlx-macpro` | `OLLAMA_HOST="http://macpro:11234" ollama launch claude` | Claude, backend MLX Serve macpro, direct dans le terminal. |
| `oc-mlx-macpro` | `OLLAMA_HOST="http://macpro:11234" ollama launch opencode` | OpenCode, backend MLX Serve macpro, direct dans le terminal. |
| `cc-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama launch claude` | Claude, backend Taichi, direct dans le terminal. |
| `oc-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama launch opencode` | OpenCode, backend Taichi, direct dans le terminal. |
| `pi-nvidia` | `pi --api-key "$NVIDIA_API_KEY"` | Pi via NVIDIA cloud, direct dans le terminal. |

---

## 3. Agents avec tmux

[↑ Sommaire](#sommaire)

Les sessions tmux restent actives apr s une d connexion. Elles sont accessibles depuis ton Samsung apr s connexion SSH au MacBook Air.

Cr er ou ouvrir une session :

```bash
tnew app-dev
tnew claude-taichi
tnew oc-mlx-macpro
```

Depuis Samsung :

```bash
tmls
tm app-dev
```

Dans tmux, `Ctrl+b` puis `d` d tache sans arr ter les processus.

### 3.1 Lancer un agent persistant

| Alias | Commande | Description |
|---|---|---|
| `cc-tmux-macpro` | `tmux new-session -A -s claude-macpro "OLLAMA_HOST=http://macpro:11434 ollama launch claude"` | Claude Code + Ollama natif macpro, dans tmux. |
| `oc-tmux-macpro` | `tmux new-session -A -s opencode-macpro "OLLAMA_HOST=http://macpro:11434 ollama launch opencode"` | OpenCode + Ollama natif macpro, dans tmux. |
| `cc-tmux-mlx-macpro` | `tmux new-session -A -s claude-mlx-macpro "OLLAMA_HOST=http://macpro:11234 ollama launch claude"` | Claude Code + MLX Serve macpro, dans tmux. |
| `oc-tmux-mlx-macpro` | `tmux new-session -A -s opencode-mlx-macpro "OLLAMA_HOST=http://macpro:11234 ollama launch opencode"` | OpenCode + MLX Serve macpro, dans tmux. |
| `cc-tmux-taichi` | `tmux new-session -A -s claude-taichi "OLLAMA_HOST=http://taichi:11434 ollama launch claude"` | Claude Code + backend Taichi, dans tmux. |
| `oc-tmux-taichi` | `tmux new-session -A -s opencode-taichi "OLLAMA_HOST=http://taichi:11434 ollama launch opencode"` | OpenCode + backend Taichi, dans tmux. |

### 3.2 G rer les sessions tmux

| Alias | Commande | Description |
|---|---|---|
| `tnew` | `tmux new-session -A -s` | Cr e une session tmux nomm e, ou s'y attache si elle existe d j . Usage : `tnew <session-name>`. |
| `tmls` | `tmux ls` | Liste toutes les sessions tmux persistantes. |
| `tm` | `tmux attach-session -d -t` | Prend une session nomm e sur ce terminal ; la d tache d'un autre terminal d'abord. Usage : `tm <session-name>`. |
| `tmwatch` | `tmux attach-session -t` | Attache sans retirer la session  un autre terminal. Pour observation. Usage : `tmwatch <session-name>`. |
| `tkill` | `tmux kill-session -t` | Tue une session et tous les programmes qui tournent dedans. Usage : `tkill <session-name>`. |
| `tname` | `tmux display-message -p '#S'` | Affiche le nom de la session tmux courante. |
| `twindows` | `tmux list-windows -a` | Liste toutes les fen tres/onglets tmux, toutes sessions confondues. |
| `tclients` | `tmux list-clients` | Liste les clients attach s aux sessions tmux. |
| `treload` | `tmux source-file ~/.tmux.conf` | Recharge une future config `~/.tmux.conf`. |

## 9. Alias sur taichi (Ubuntu)

[↑ Sommaire](#sommaire)

La config Nix s'applique maintenant à **deux machines** : le MacBook Air (nix-darwin) et **taichi** (Ubuntu, standalone home-manager). Les sections 1 à 7 décrivent la partie macOS.

### 9.1 Config commune aux deux machines

Ces alias fonctionnent à l'identique sur les deux hosts, car Tailscale route les noms :

| Alias | Commande | Description |
|---|---|---|
| `ol` / `ol-list` | `ollama` / `ollama list` | Ollama par défaut → `http://macpro:11434` (l'autre machine). |
| `ol-macpro` | `OLLAMA_HOST=http://macpro:11434 ollama` | Ollama du Mac Pro via Tailscale (depuis taichi = autre machine). |
| `ol-taichi` | `OLLAMA_HOST=http://taichi:11434 ollama` | Ollama de taichi (depuis le Mac = autre machine). |
| `ol-local` | `OLLAMA_HOST=http://127.0.0.1:11434 ollama` | Ollama **natif** de la machine courante. |
| `cc-mlx-macpro` | `~/.local/bin/cc-mlx-picker` | Sélecteur interactif de modèles MLX Serve (marche depuis taichi via Tailscale). |
| `pi-local` | `pi` | Pi sur le provider par défaut (`taichi-ollama` → 11434 de la machine courante). |
| `pi-macpro` / `pi-taichi` / `pi-mlx-macpro` | `pi --provider <...>` | Providers définis dans `home/.pi/agent/models.json` (fonctionnent sur les deux machines). |
| `pi-nvidia` / `pinvidia` / `pinvidia-ultra` / `pideepseek` | `pi --provider nvidia` | NVIDIA Build (clé dans `secrets/env` → à copier sur taichi). |
| `pi-tmux-*` / `tnew` / `tmls` / `tm` / `tmwatch` / `tkill` / `tname` / `twindows` / `tclients` / `treload` | idem | Sessions tmux et gestion tmux. |

### 9.2 Supprimés sur taichi (spécifiques Ollama Desktop)

`ollama launch <app>` (utilisé par `cc-macpro`, `cc-taichi`, `oc-macpro`, `oc-taichi`), `launchctl setenv`, et `open -a Ollama` n'existent que sur macOS.

### 9.3 Équivalents sur taichi (CLI + variables d'env)

| Alias | Commande | Description |
|---|---|---|
| `cc-macpro` | `ANTHROPIC_API_KEY=ollama ANTHROPIC_BASE_URL=http://macpro:11434 claude` | Claude Code CLI (paquet Nix `nodePackages."@anthropic-ai/claude-code"`) branché sur l'API Anthropic-compatible de macpro. |
| `cc-taichi` | `ANTHROPIC_API_KEY=ollama ANTHROPIC_BASE_URL=http://127.0.0.1:11434 claude` | Claude Code branché sur l'Ollama **natif** de taichi. |
| `oc-macpro` | `opencode` | OpenCode avec le provider par défaut (`macpro-ollama` dans `opencode.json`), via Tailscale. |
| `oc-mlx-macpro` | `opencode -m macpro-mlx/Qwen3.8-Flash-Next-oQ4e-MTP-128k` | OpenCode branché sur MLX Serve (provider `macpro-mlx` ajouté à `opencode.json`). |
| `cc-tmux-macpro` / `cc-tmux-taichi` | `tmux new-session -A -s <nom> "ANTHROPIC_BASE_URL=… claude"` | Versions tmux persistantes (créer avec `tnew` si absent). |
| `oc-tmux-macpro` | `tmux new-session -A -s opencode-macpro "opencode"` | OpenCode + macpro Ollama en tmux. |
| `oc-tmux-mlx-macpro` | `tmux new-session -A -s opencode-mlx-macpro "opencode -m macpro-mlx/…"` | OpenCode + MLX Serve en tmux. |
| `ol-tunnels` / `ol-stop-tunnels` | `ssh -fN -L 127.0.0.1:12435:localhost:11434 maclino@macpro` | Un seul tunnel (vers macpro) : pas de tunnel SSH *vers taichi* puisque c'est taichi. |
| `ol-tunnel-macpro` | `OLLAMA_HOST=http://127.0.0.1:12435 ollama` | Ollama macpro via tunnel SSH de secours. |

### 9.4 Appli qui n'existe pas dans Nixpkgs

- Si le paquet est dans `nixpkgs` pour `x86_64-linux` : l'ajouter à `home.packages` dans `home.nix`, puis `home-manager switch --flake ~/.dotfiles#taichi`.
- Sinon (ex. `herdr`, seulement en cask Homebrew sur le Mac) : Nix ne peut pas l'installer sur taichi. Les fichiers de *config* dans `home/` restent partagés, mais il faut installer le *binaire* à la main sur taichi (`apt`, AppImage, npm…).

---

## 4. Raccourcis clavier tmux

[↑ Sommaire](#sommaire)

Pr fixe par d faut : `Ctrl+b`. Appuie sur `Ctrl+b`, rel che, puis appuie sur la touche indiqu e.

### Sessions

| Raccourci | Action |
|---|---|
| `Ctrl+b` puis `d` | D tache la session courante sans arr ter les processus. |
| `Ctrl+b` puis `s` | Liste les sessions et permet d'en changer. |
| `Ctrl+b` puis `$` | Renomme la session courante. |

### Fen tres

| Raccourci | Action |
|---|---|
| `Ctrl+b` puis `c` | Cr e une nouvelle fen tre. |
| `Ctrl+b` puis `n` | Fen tre suivante. |
| `Ctrl+b` puis `p` | Fen tre pr c dente. |
| `Ctrl+b` puis `0`   `9` | Va  la fen tre num ro indiqu . |
| `Ctrl+b` puis `,` | Renomme la fen tre courante. |
| `Ctrl+b` puis `&` | Ferme la fen tre courante, avec confirmation. |
| `Ctrl+b` puis `w` | Liste les fen tres. |

### Panneaux

| Raccourci | Action |
|---|---|
| `Ctrl+b` puis `%` | Split vertical, gauche/droite. |
| `Ctrl+b` puis `"` | Split horizontal, haut/bas. |
| `Ctrl+b` puis fl che | Se d place vers le panneau dans cette direction. |
| `Ctrl+b` puis `x` | Ferme le panneau courant, avec confirmation. |
| `Ctrl+b` puis `z` | Zoom/d zoom le panneau courant. |
| `Ctrl+b` puis `q` | Affiche bri vement les num ros des panneaux. |

### Copie et d filement

| Raccourci | Action |
|---|---|
| `Ctrl+b` puis `[` | Entre en mode copie/d filement. |
| `q` | Quitte le mode copie. |
| `Espace` | D marre une s lection en mode copie. |
| `Entr e` | Copie la s lection dans le buffer. |
| `Ctrl+b` puis `]` | Colle le dernier buffer copi . |

### Divers

| Raccourci | Action |
|---|---|
| `Ctrl+b` puis `:` | Ligne de commande tmux. |
| `Ctrl+b` puis `?` | Liste tous les raccourcis tmux. |

---

## 5. Raccourcis clavier WezTerm

[↑ Sommaire](#sommaire)

### Fen tres et onglets

| Raccourci | Action |
|---|---|
| `CMD+t` | Nouvel onglet. |
| `CMD+n` | Nouvelle fen tre. |
| `CMD+w` | Ferme l'onglet/panneau courant, avec confirmation. |
| `CMD+Shift+w` | Ferme la fen tre courante, avec confirmation. |

### Souris

| Raccourci | Action |
|---|---|
| `CMD` + clic gauche + glisser | D place la fen tre WezTerm. |

### Apparence

- Th me : `rose-pine-moon`
- Police : `Hack Nerd Font`, taille 15
- Opacit  du fond : 0.8
- Flou du fond sur macOS : 50
- Barre d'onglets masqu e s'il n'y a qu'un seul onglet
- D corations de fen tre : `RESIZE` uniquement
- Fen tre non focalis e : texte assombri et opacit  r duite pour rep rer la fen tre active.

---

## 6. Raccourcis clavier Neovim

[↑ Sommaire](#sommaire)

### Basique

| Raccourci | Mode | Action |
|---|---|---|
| ` chap` | Normal | Sauvegarde (`:update`). |
| `Ctrl+s` | Normal, Insertion, Visuel | Sauvegarde (`:update`). |
| `Ctrl+a` | Normal | S lectionne tout (`ggVG`). |
| `p` sur une s lection | Visuel | Colle sans perdre le contenu du clipboard. |

### Fichiers / buffers

| Raccourci | Mode | Action |
|---|---|---|
| `<leader>w` | Normal | Sauvegarde (`:write`). |
| `<leader>q` | Normal | Quitte (`:quit`). |
| `<leader>x` | Normal | Ferme le buffer (`:bdelete`). |
| `<leader>bn` | Normal | Buffer suivant (`:bnext`). |
| `<leader>bp` | Normal | Buffer pr c dent (`:bprevious`). |

### Fen tres

| Raccourci | Mode | Action |
|---|---|---|
| `Ctrl+h` | Normal | Se d place vers la fen tre de gauche. |
| `Ctrl+l` | Normal | Se d place vers la fen tre de droite. |
| `Ctrl+j` | Normal | Se d place vers la fen tre du bas. |
| `Ctrl+k` | Normal | Se d place vers la fen tre du haut. |
| `<leader>sv` | Normal | Split vertical (`:vsplit`). |
| `<leader>sh` | Normal | Split horizontal (`:split`). |
| `<leader>sx` | Normal | Ferme le split (`:close`). |

### LSP

| Raccourci | Mode | Action |
|---|---|---|
| `gd` | Normal | Va  la d finition. |
| `gD` | Normal | Va  la d claration. |
| `gr` | Normal | R f rences. |
| `gi` | Normal | Va  l'impl mentation. |
| `K` | Normal | Documentation au survol. |
| `<leader>rn` | Normal | Renomme le symbole. |
| `<leader>ca` | Normal, Visuel | Actions de code. |
| `<leader>ld` | Normal | Diagnostics de la ligne. |
| `[d` | Normal | Diagnostic pr c dent. |
| `]d` | Normal | Diagnostic suivant. |

### Terminal

| Raccourci | Mode | Action |
|---|---|---|
| `<leader>t` | Normal | Ouvre un terminal (`:terminal`). |

---

## 7. Raccourcis clavier macOS

[↑ Sommaire](#sommaire)

### Applications et fen tres

| Raccourci | Action |
|---|---|
| `CMD+Espace` | Ouvre Spotlight. |
| `CMD+Tab` | Passe  l'application suivante. |
| `CMD+Shift+Tab` | Passe  l'application pr c dente. |
| `CMD+W` | Ferme la fen tre ou l'onglet actif. |
| `CMD+Q` | Quitte l'application active. |
| `CMD+H` | Masque l'application active. |
| `CMD+Option+H` | Masque toutes les autres applications. |
| `CMD+M` | R duit la fen tre active dans le Dock. |
| `CMD+Option+M` | R duit toutes les fen tres de l'application active. |
| `Ctrl+Fl che bas` | Mission Control. |
| `Ctrl+Fl che haut` | Affiche les fen tres de l'application active. |
| `Ctrl+Fl che gauche/droite` | Change d'espace (bureau). |
| `Ctrl+CMD+F` | Active ou quitte le plein cran. |

### Navigation clavier

| Raccourci | Action |
|---|---|
| `Tab` | Contr le suivant. |
| `Shift+Tab` | Contr le pr c dent. |
| `Espace` | Active le contr le s lectionn . |
| `Entr e` | Valide l'action ou ouvre l' l ment s lectionn . |
| ` chap` | Annule ou ferme le menu ou la bo te de dialogue. |
| `Ctrl+F2` | Focus sur la barre des menus. |
| `Ctrl+F3` | Focus sur le Dock. |
| `Ctrl+F4` | Fen tre suivante de l'application active. |
| `Ctrl+F7` | Active ou d sactive la navigation compl te au clavier. |
| `Ctrl+F8` | Focus sur les menus de statut. |

> Sur MacBook, ajoute `Fn` aux touches `F1`   `F12` selon les r glages clavier.

### Finder et fichiers

| Raccourci | Action |
|---|---|
| `CMD+N` | Nouvelle fen tre Finder. |
| `CMD+T` | Nouvel onglet Finder. |
| `CMD+Fl che haut` | Dossier parent. |
| `CMD+Fl che bas` | Ouvre le fichier ou dossier s lectionn . |
| `CMD+[` | Emplacement pr c dent. |
| `CMD+]` | Emplacement suivant. |
| `CMD+Shift+G` | Aller au dossier. |
| `CMD+Shift+H` | Dossier personnel. |
| `CMD+Shift+D` | Bureau. |
| `CMD+Shift+O` | Documents. |
| `CMD+Shift+U` | Utilitaires. |
| `CMD+Shift+.` | Affiche ou masque les fichiers cach s. |
| `Espace` | Aper u rapide. |
| `Entr e` | Renomme l' l ment s lectionn . |
| `CMD+Suppr` | Envoie  la Corbeille. |
| `CMD+Shift+Suppr` | Vide la Corbeille, avec confirmation. |
| `CMD+D` | Duplique l' l ment. |
| `CMD+I` | Informations sur l' l ment. |
| `CMD+1` | Vue en ic nes. |
| `CMD+2` | Vue en liste. |
| `CMD+3` | Vue en colonnes. |
| `CMD+4` | Vue en galerie. |

### dition de texte

| Raccourci | Action |
|---|---|
| `CMD+C` | Copie. |
| `CMD+X` | Coupe. |
| `CMD+V` | Colle. |
| `CMD+Z` | Annule. |
| `CMD+Shift+Z` | R tablit. |
| `CMD+A` | S lectionne tout. |
| `CMD+F` | Recherche. |
| `CMD+G` | R sultat suivant. |
| `CMD+Shift+G` | R sultat pr c dent. |
| `CMD+S` | Enregistre. |
| `CMD+P` | Imprime. |
| `CMD+Fl che gauche/droite` | D but ou fin de ligne. |
| `Option+Fl che gauche/droite` | D place le curseur d'un mot. |
| `Shift+Fl che` | tend la s lection. |
| `Option+Shift+Fl che gauche/droite` | tend la s lection d'un mot. |
| `CMD+Shift+Fl che gauche/droite` | S lectionne jusqu'au d but ou  la fin de ligne. |
| `CMD+Fl che haut/bas` | D but ou fin du document. |
| `Option+Suppr` | Supprime le mot pr c dent. |
| `Fn+Suppr` | Supprime vers l'avant. |
| `CMD+Suppr` | Supprime jusqu'au d but de la ligne. |

### Captures d' cran

| Raccourci | Action |
|---|---|
| `CMD+Shift+3` | Capture l' cran entier. |
| `CMD+Shift+4` | Capture une zone ; `Espace` pour capturer une fen tre. |
| `CMD+Shift+5` | Outils de capture et d'enregistrement. |
| `CMD+Shift+6` | Capture la Touch Bar, si disponible. |
| Ajoute `Ctrl` | Copie la capture dans le presse-papiers au lieu de l'enregistrer. |

### Veille, verrouillage, alimentation

| Raccourci | Action |
|---|---|
| `Ctrl+CMD+Q` | Verrouille l' cran imm diatement. |
| `CMD+Option+ jecter` | Met le Mac en veille imm diatement, si touche jecter pr sente. |
| `CMD+Option+Touch ID` | Met le Mac en veille imm diatement, sur MacBook avec Touch ID. |
| `Ctrl+Shift+Bouton d'alimentation` | Met uniquement l' cran en veille. |
| `Ctrl+CMD+Bouton d'alimentation` | D marre, avec confirmation ventuelle. |
| `Ctrl+Option+CMD+Bouton d'alimentation` | teint, avec confirmation ventuelle. |
| Maintenir le bouton d'alimentation | Force l'arr t, en cas de blocage uniquement. |

### R glages rapides

| Raccourci | Action |
|---|---|
| `CMD+,` | R glages de l'application active. |
| `Option+clic` sur Wi-Fi/Bluetooth/son/batterie | Options suppl mentaires dans la barre des menus. |
| `Option+Luminosit ` | R glages d' cran directement. |
| `Option+Volume` | R glages audio directement. |
| `Option+Clavier` | R glages clavier directement. |

---

## 8. Routine rapide

[↑ Sommaire](#sommaire)

```bash
# Agents sans tmux — s'arr tent si le terminal se ferme
cc-macpro                  # Ollama natif sur macpro
oc-macpro                  # Ollama natif sur macpro
cc-mlx-macpro              # MLX Serve sur macpro
oc-mlx-macpro              # MLX Serve sur macpro
cc-taichi                  # Ollama sur Taichi
pi-nvidia                  # NVIDIA cloud

# Agents persistants — continuent apr s d connexion
cc-tmux-macpro
oc-tmux-macpro
cc-tmux-mlx-macpro
oc-tmux-mlx-macpro
cc-tmux-taichi
oc-tmux-taichi

# Inspecter les mod les
ol-macpro list             # Ollama natif, macpro:11434
ol-mlx-macpro list         # MLX Serve, macpro:11234
ol-taichi list             # Ollama, taichi:11434

# Ex cuter Flash Next sur MLX Serve
ol-mlx-macpro run ddalcu/Qwen3.8-Flash-Next-MLX-Serve-4bit:latest

# Session de d veloppement persistante personnalis e
tnew app-dev
tmls
tm app-dev

# Mod le sur Taichi
ol-taichi pull <nom-du-mod le>
ol-taichi run <nom-du-mod le>

# Arr t d finitif d'une session
tkill app-dev
```

```text
Dans tmux : Ctrl+b, puis d  →  d tache sans arr ter les processus
WezTerm   : CMD+t  →  nouvel onglet
Neovim    : <leader>w  →  sauvegarde ; gd  →  d finition
macOS     : CMD+Espace  →  Spotlight ; Ctrl+CMD+Q  →  verrouiller l' cran
```
