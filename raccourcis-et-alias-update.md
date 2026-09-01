# Référence complète — Zsh, agents, tmux, WezTerm, Neovim et macOS

## Sommaire

- [1. Alias Zsh](#1-alias-zsh)
  - [1.1 Navigation](#11-navigation)
  - [1.2 Git](#12-git)
  - [1.3 Éditeur](#13-editeur)
  - [1.4 Fichiers](#14-fichiers)
  - [1.5 Ollama — serveurs directs via Tailscale](#15-ollama--serveurs-directs-via-tailscale)
  - [1.5.1 MLX Serve sur macpro](#151-mlx-serve-sur-macpro)
  - [1.6 Claude Desktop via Ollama + tunnels SSH + MLX Serve](#16-claude-desktop-via-ollama--tunnels-ssh--mlx-serve)
  - [1.7 NVIDIA Build / NIM via Pi](#17-nvidia-build--nim-via-pi)
- [2. Agents sans tmux](#2-agents-sans-tmux)
- [3. Agents avec tmux](#3-agents-avec-tmux)
  - [3.1 Lancer un agent persistant](#31-lancer-un-agent-persistant)
  - [3.2 Gérer les sessions tmux](#32-gerer-les-sessions-tmux)
- [4. Raccourcis clavier tmux](#4-raccourcis-clavier-tmux)
- [5. Raccourcis clavier WezTerm](#5-raccourcis-clavier-wezterm)
- [6. Raccourcis clavier Neovim](#6-raccourcis-clavier-neovim)
- [7. Raccourcis clavier macOS](#7-raccourcis-clavier-macos)
- [8. Routine rapide](#8-routine-rapide)

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
| `add` | `git add .` | Ajoute tous les fichiers modifiés au staging. |
| `push` | `git push` | Pousse les commits vers le remote. |
| `pull` | `git pull` | Tire les commits depuis le remote. |
| `gs` | `git status` | Affiche l'état du dépôt Git. |
| `lg` | `lazygit` | Ouvre l'interface Lazygit. |
| `m` | `git switch main` | Bascule sur la branche `main`. |

### 1.3 Éditeur

| Alias | Commande | Description |
|---|---|---|
| `v` | `nvim` | Ouvre Neovim. |
| `vi` | `nvim` | Ouvre Neovim. |

### 1.4 Fichiers

| Alias | Commande | Description |
|---|---|---|
| `ll` | `eza -la` | Liste les fichiers en détail. |
| `cat` | `bat` | Affiche un fichier avec coloration syntaxique. |

### 1.5 Ollama — serveurs directs via Tailscale

Ces commandes ne nécessitent pas de tunnel SSH et gardent ton workflow intact.

| Alias | Commande | Description |
|---|---|---|
| `ol` | `ollama` | Serveur par défaut, hérité de `OLLAMA_HOST` : macpro. |
| `ol-list` | `ollama list` | Liste les modèles du serveur par défaut. |
| `ol-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama` | Ollama natif sur macpro. |
| `cc-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama launch claude` | Claude Code via macpro. |
| `oc-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama launch opencode` | OpenCode via macpro. |
| `ol-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama` | Ollama natif sur Taichi. |
| `cc-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama launch claude` | Claude Code via Taichi. |
| `oc-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama launch opencode` | OpenCode via Taichi. |
| `ol-local` | `OLLAMA_HOST="http://127.0.0.1:11434" ollama` | Ollama local sur le MacBook Air. |

Gestion Taichi :

```bash
ol-taichi list
ol-taichi pull <nom-du-modèle>
ol-taichi run <nom-du-modèle>
ol-taichi rm <nom-du-modèle>
ol-taichi ps
```

### 1.5.1 MLX Serve sur macpro

MLX Serve est un second serveur sur macpro. Il est accessible via Tailscale à `http://macpro:11234`.

| Alias | Commande | Description |
|---|---|---|
| `ol-mlx-macpro` | `OLLAMA_HOST="http://macpro:11234" ollama` | CLI Ollama vers MLX Serve. |
| `ol-mlx-list` | `OLLAMA_HOST="http://macpro:11234" ollama list` | Liste les modèles MLX. |
| `ol-mlx-ps` | `OLLAMA_HOST="http://macpro:11234" ollama ps` | Liste les modèles MLX actifs. |
| `ol-mlx-run` | `OLLAMA_HOST="http://macpro:11234" ollama run` | Lance un modèle MLX. |
| `mlx-status` | `curl -sS http://macpro:11234/api/tags` | Vérifie l'API Ollama-compatible. |
| `mlx-models` | `curl -sS http://macpro:11234/v1/models` | Liste l'API OpenAI-compatible. |
| `cc-mlx-macpro` | `$HOME/.local/bin/cc-mlx-picker` | Propose un modèle puis lance Claude Code. |
| `oc-mlx-macpro` | `OLLAMA_HOST="http://macpro:11234" ollama launch opencode` | OpenCode via MLX Serve. |

Le picker Claude interroge la liste MLX à chaque lancement et passe le modèle choisi à Claude Code avec `--model`. Aucun modèle MLX n'est forcé dans les réglages globaux Claude.

Modèles MLX confirmés :

```text
labhraighlep/Qwen3.8-Flash-Next-MLX-Serve-4bit
mlx-community/Muse-Glimmer-30B-4bit
Qwen3.8-Flash-Next-oQ4e-MTP-128k
```

### 1.6 Claude Desktop via Ollama + tunnels SSH + MLX Serve

Mapping des ports :

- `127.0.0.1:11434` → Ollama local.
- `127.0.0.1:12435` → `macpro:11434` via SSH.
- `127.0.0.1:11436` → `taichi:11434` via SSH.
- `macpro:11234` → MLX Serve direct via Tailscale.

| Alias | Commande / action | Description |
|---|---|---|
| `ol-tunnels` | Deux commandes SSH `-fN` | Démarre les tunnels macpro et Taichi. |
| `ol-stop-tunnels` | Deux commandes `pkill` ciblées | Arrête uniquement ces tunnels. |
| `ol-tunnel-macpro` | `OLLAMA_HOST="http://127.0.0.1:12435" ollama` | Teste Ollama macpro via tunnel. |
| `ol-tunnel-taichi` | `OLLAMA_HOST="http://127.0.0.1:11436" ollama` | Teste Ollama Taichi via tunnel. |
| `claude-local` | `launchctl setenv ...; open -a Ollama` | Ouvre Ollama local. |
| `claude-macpro` | `launchctl setenv ...; open -a Ollama` | Ouvre Ollama via tunnel macpro. |
| `claude-taichi` | `launchctl setenv ...; open -a Ollama` | Ouvre Ollama via tunnel Taichi. |
| `claude-mlx-macpro` | `launchctl setenv ...; open -a Ollama` | Ouvre Ollama sur MLX Serve. |

## 2. Agents sans tmux

Ces aliases s'exécutent dans le terminal courant.

| Alias | Backend / commande |
|---|---|
| `cc` | `claude --dangerously-skip-permissions` |
| `oc` | `opencode` |
| `cc-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama launch claude` |
| `oc-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama launch opencode` |
| `cc-mlx-macpro` | `$HOME/.local/bin/cc-mlx-picker` |
| `oc-mlx-macpro` | `OLLAMA_HOST="http://macpro:11234" ollama launch opencode` |
| `cc-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama launch claude` |
| `oc-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama launch opencode` |
| `pi-local` | `pi` |
| `pi-macpro` | `pi --provider macpro-ollama` |
| `pi-taichi` | `pi --provider taichi-ollama` |
| `pi-mlx-macpro` | `pi --provider macpro-mlx` |
| `pi-omlx` | `pi --provider macbook-omlx` |
| `pi-nvidia` | `pi --provider nvidia` |
| `pinvidia` | `pi --provider nvidia --model nvidia/nemotron-3-super-120b-a12b` |
| `pinvidia-ultra` | `pi --provider nvidia --model nvidia/nemotron-3-ultra-550b-a55b` |
| `pideepseek` | `pi --provider nvidia --model deepseek-ai/deepseek-v4-pro-0813` |

## 3. Agents avec tmux

Les sessions tmux restent actives après une déconnexion.

### 3.1 Lancer un agent persistant

| Alias | Session | Commande / backend |
|---|---|---|
| `cc-tmux-macpro` | `claude-macpro` | Claude + Ollama macpro |
| `cc-tmux-taichi` | `claude-taichi` | Claude + Ollama Taichi |
| `cc-tmux-mlx-macpro` | `claude-mlx-macpro` | Claude + picker MLX |
| `oc-tmux-macpro` | `opencode-macpro` | OpenCode + Ollama macpro |
| `oc-tmux-taichi` | `opencode-taichi` | OpenCode + Ollama Taichi |
| `oc-tmux-mlx-macpro` | `opencode-mlx-macpro` | OpenCode + MLX Serve |
| `pi-tmux-macpro` | `pi-macpro` | Pi + `macpro-ollama` |
| `pi-tmux-taichi` | `pi-taichi` | Pi + `taichi-ollama` |
| `pi-tmux-mlx-macpro` | `pi-mlx-macpro` | Pi + `macpro-mlx` |
| `pi-tmux-omlx` | `pi-omlx` | Pi + `macbook-omlx` |
| `pi-tmux-nvidia` | `pi-nvidia` | Pi + `nvidia` |

Commandes :

```bash
cc-tmux-macpro
cc-tmux-taichi
cc-tmux-mlx-macpro
oc-tmux-macpro
oc-tmux-taichi
oc-tmux-mlx-macpro
pi-tmux-macpro
pi-tmux-taichi
pi-tmux-mlx-macpro
pi-tmux-omlx
pi-tmux-nvidia
```

### 3.2 Gérer les sessions tmux

| Alias | Commande | Fonction |
|---|---|---|
| `tnew` | `tmux new-session -A -s` | Crée ou rejoint une session. |
| `tmls` | `tmux ls` | Liste les sessions. |
| `tm` | `tmux attach-session -d -t` | Rejoint une session en détachant l'autre client. |
| `tmwatch` | `tmux attach-session -t` | Observe une session. |
| `tkill` | `tmux kill-session -t` | Arrête une session. |
| `tname` | `tmux display-message -p '#S'` | Affiche le nom courant. |
| `twindows` | `tmux list-windows -a` | Liste les fenêtres. |
| `tclients` | `tmux list-clients` | Liste les clients. |
| `treload` | `tmux source-file ~/.tmux.conf` | Recharge la configuration tmux. |

Exemples :

```bash
tmls
tm pi-nvidia
tm claude-taichi
tkill pi-nvidia
```

### Sessions Pi et NVIDIA

Pour NVIDIA, la clé est lue depuis la variable `NVIDIA_API_KEY` chargée par `secrets/env` et déclarée dans le provider Pi `nvidia`.

```bash
pi-nvidia
pi-tmux-nvidia
pinvidia
pinvidia-ultra
pideepseek
```

Si une session tmux affiche `[exited]`, ferme l'ancienne session et teste d'abord sans tmux :

```bash
tkill pi-nvidia 2>/dev/null || true
pi-nvidia
```

## 4. Raccourcis clavier tmux

Préfixe par défaut : `Ctrl+b`. Appuie sur `Ctrl+b`, relâche, puis appuie sur la touche.

| Raccourci | Action |
|---|---|
| `Ctrl+b`, `d` | Détache sans arrêter les processus. |
| `Ctrl+b`, `s` | Liste les sessions. |
| `Ctrl+b`, `c` | Nouvelle fenêtre. |
| `Ctrl+b`, `n` | Fenêtre suivante. |
| `Ctrl+b`, `p` | Fenêtre précédente. |
| `Ctrl+b`, `%` | Split vertical. |
| `Ctrl+b`, `"` | Split horizontal. |
| `Ctrl+b`, flèche | Change de panneau. |
| `Ctrl+b`, `x` | Ferme le panneau courant. |
| `Ctrl+b`, `z` | Zoom/dézoom. |
| `Ctrl+b`, `[` | Mode copie/défilement. |
| `q` | Quitte le mode copie. |
| `Ctrl+b`, `]` | Colle le buffer. |
| `Ctrl+b`, `:` | Ligne de commande tmux. |
| `Ctrl+b`, `?` | Aide tmux. |

## 5. Raccourcis clavier WezTerm

| Raccourci | Action |
|---|---|
| `CMD+t` | Nouvel onglet. |
| `CMD+n` | Nouvelle fenêtre. |
| `CMD+w` | Ferme l'onglet ou le panneau. |
| `CMD+Shift+w` | Ferme la fenêtre. |
| `CMD` + clic gauche + glisser | Déplace la fenêtre. |

Configuration : thème `rose-pine-moon`, Hack Nerd Font taille 15, opacité 0.8, flou macOS 50, barre d'onglets masquée s'il n'y en a qu'un, décorations `RESIZE` uniquement.

## 6. Raccourcis clavier Neovim

### Basique

| Raccourci | Action |
|---|---|
| `Ctrl+s` | Sauvegarde. |
| `Ctrl+a` | Sélectionne tout. |
| `p` en mode visuel | Colle sans perdre le clipboard. |
| `<leader>w` | Sauvegarde. |
| `<leader>q` | Quitte. |
| `<leader>x` | Ferme le buffer. |
| `<leader>bn` | Buffer suivant. |
| `<leader>bp` | Buffer précédent. |

### Fenêtres, LSP et terminal

| Raccourci | Action |
|---|---|
| `Ctrl+h/j/k/l` | Change de fenêtre. |
| `<leader>sv` | Split vertical. |
| `<leader>sh` | Split horizontal. |
| `<leader>sx` | Ferme le split. |
| `gd` | Va à la définition. |
| `gD` | Va à la déclaration. |
| `gr` | Références. |
| `gi` | Implémentation. |
| `K` | Documentation au survol. |
| `<leader>rn` | Renomme le symbole. |
| `<leader>ca` | Actions de code. |
| `<leader>ld` | Diagnostics de la ligne. |
| `[d` / `]d` | Diagnostic précédent / suivant. |
| `<leader>t` | Ouvre un terminal. |

## 7. Raccourcis clavier macOS

### Applications et fenêtres

| Raccourci | Action |
|---|---|
| `CMD+Espace` | Spotlight. |
| `CMD+Tab` | Application suivante. |
| `CMD+Shift+Tab` | Application précédente. |
| `CMD+W` | Ferme la fenêtre ou l'onglet. |
| `CMD+Q` | Quitte l'application. |
| `CMD+H` | Masque l'application. |
| `CMD+Option+H` | Masque les autres applications. |
| `CMD+M` | Réduit la fenêtre. |
| `Ctrl+Flèche bas` | Mission Control. |
| `Ctrl+Flèche haut` | Fenêtres de l'application. |
| `Ctrl+Flèche gauche/droite` | Change d'espace. |
| `Ctrl+CMD+F` | Plein écran. |
| `Ctrl+CMD+Q` | Verrouille l'écran. |

### Finder et édition

| Raccourci | Action |
|---|---|
| `CMD+N` | Nouvelle fenêtre Finder. |
| `CMD+T` | Nouvel onglet. |
| `CMD+Flèche haut` | Dossier parent. |
| `CMD+Shift+G` | Aller au dossier. |
| `CMD+Shift+H` | Dossier personnel. |
| `CMD+Shift+.` | Affiche les fichiers cachés. |
| `Espace` | Aperçu rapide. |
| `Entrée` | Renommer. |
| `CMD+Suppr` | Corbeille. |
| `CMD+D` | Dupliquer. |
| `CMD+I` | Informations. |
| `CMD+C` | Copie. |
| `CMD+X` | Coupe. |
| `CMD+V` | Colle. |
| `CMD+Z` | Annule. |
| `CMD+Shift+Z` | Rétablit. |
| `CMD+A` | Sélectionne tout. |
| `CMD+F` | Recherche. |
| `CMD+S` | Enregistre. |
| `CMD+P` | Imprime. |

## 8. Routine rapide

```bash
# Rebuild
cd ~/dotfiles
./rebuild.sh
exec zsh

# Vérifier les alias Pi
alias pi-macpro
alias pi-taichi
alias pi-mlx-macpro
alias pi-omlx
alias pi-nvidia
alias pi-tmux-nvidia

# Vérifier les backends
ol-macpro list
ol-taichi list
ol-mlx-list
mlx-models | jq

# Agents directs
cc-macpro
cc-taichi
cc-mlx-macpro
oc-macpro
oc-taichi
oc-mlx-macpro

# Pi directs
pi-macpro
pi-taichi
pi-mlx-macpro
pi-omlx
pi-nvidia

# Agents persistants
cc-tmux-macpro
cc-tmux-taichi
cc-tmux-mlx-macpro
oc-tmux-macpro
oc-tmux-taichi
oc-tmux-mlx-macpro
pi-tmux-macpro
pi-tmux-taichi
pi-tmux-mlx-macpro
pi-tmux-omlx
pi-tmux-nvidia

# Sessions tmux
tmls
tm <session>
tkill <session>
```

Dans tmux : `Ctrl+b`, puis `d` détache sans arrêter l'agent.
