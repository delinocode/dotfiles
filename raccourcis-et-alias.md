# Référence complète — Zsh, agents, tmux, WezTerm, Neovim et macOS

## Sommaire

- [1. Alias Zsh](#1-alias-zsh)
  - [1.1 Navigation](#11-navigation)
  - [1.2 Git](#12-git)
  - [1.3 Éditeur](#13-éditeur)
  - [1.4 Fichiers](#14-fichiers)
  - [1.5 Ollama — serveurs directs via Tailscale](#15-ollama--serveurs-directs-via-tailscale)
  - [1.6 Claude Desktop via Ollama + tunnels SSH](#16-claude-desktop-via-ollama--tunnels-ssh)
  - [1.7 NVIDIA Build / NIM via Pi](#17-nvidia-build--nim-via-pi)
- [2. Agents sans tmux](#2-agents-sans-tmux)
- [3. Agents avec tmux](#3-agents-avec-tmux)
  - [3.1 Lancer un agent persistant](#31-lancer-un-agent-persistant)
  - [3.2 Gérer les sessions tmux](#32-gérer-les-sessions-tmux)
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
| `pull` | `git pull` | Tire les changements depuis le remote. |
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
| `ol` | `ollama` | Serveur Ollama par défaut, hérité de `OLLAMA_HOST` (macpro). |
| `ol-list` | `ollama list` | Liste les modèles du serveur par défaut. |
| `ol-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama` | macpro — Apple Silicon / 128 Go de RAM, connexion directe. |
| `cc-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama launch claude` | Lance Claude via macpro, connexion directe. |
| `oc-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama launch opencode` | Lance OpenCode via macpro, connexion directe. |
| `ol-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama` | Taichi — Ubuntu / 2× RTX 3090, connexion directe. |
| `cc-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama launch claude` | Lance Claude via Taichi, connexion directe. |
| `oc-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama launch opencode` | Lance OpenCode via Taichi, connexion directe. |

#### Gérer les modèles sur Taichi

```bash
ol-taichi list                     # Modèles installés sur Taichi
ol-taichi pull <nom-du-modèle>     # Télécharger un modèle sur Taichi
ol-taichi run <nom-du-modèle>      # Exécuter un modèle sur Taichi
ol-taichi rm <nom-du-modèle>       # Supprimer un modèle de Taichi
ol-taichi ps                       # Modèles actuellement actifs
```

### 1.6 Claude Desktop via Ollama + tunnels SSH

Mapping des ports :

- `127.0.0.1:11434` → Ollama local, app/modèles sur ce Mac
- `127.0.0.1:12435` → `macpro:11434`, utilisateur SSH `maclino`
- `127.0.0.1:11436` → `taichi:11434`, utilisateur SSH `delai`

Ces alias ne modifient pas `OLLAMA_HOST` global ni ton application existante.

| Alias | Commande | Description |
|---|---|---|
| `ol-tunnels` | `ssh -fN -L 127.0.0.1:12435:localhost:11434 maclino@macpro`<br>`ssh -fN -L 127.0.0.1:11436:localhost:11434 delai@taichi` | Démarre les deux tunnels Ollama distants en arrière-plan. |
| `ol-stop-tunnels` | `pkill -f "ssh -fN -L 127.0.0.1:12435:localhost:11434 maclino@macpro" \|\| true`<br>`pkill -f "ssh -fN -L 127.0.0.1:11436:localhost:11434 delai@taichi" \|\| true` | Arrête uniquement ces deux tunnels SSH exacts. |
| `ol-local` | `OLLAMA_HOST="http://127.0.0.1:11434" ollama` | Inspecte les modèles installés localement. |
| `ol-tunnel-macpro` | `OLLAMA_HOST="http://127.0.0.1:12435" ollama` | Inspecte les modèles de macpro via le tunnel. |
| `ol-tunnel-taichi` | `OLLAMA_HOST="http://127.0.0.1:11436" ollama` | Inspecte les modèles de Taichi via le tunnel. |
| `claude-local` | Définit `OLLAMA_HOST` sur `127.0.0.1:11434`, tue puis relance Claude Desktop. | Claude Desktop → modèles installés localement sur ce Mac. |
| `claude-macpro` | Définit `OLLAMA_HOST` sur `127.0.0.1:12435`, tue puis relance Claude Desktop. | Claude Desktop → modèles macpro, via le tunnel SSH macpro. |
| `claude-taichi` | Définit `OLLAMA_HOST` sur `127.0.0.1:11436`, tue puis relance Claude Desktop. | Claude Desktop → modèles Taichi, via le tunnel SSH Taichi. |

### 1.7 NVIDIA Build / NIM via Pi

Choix du modèle possible dans Pi avec `/model` ou `Ctrl+L`.

| Alias | Commande | Description |
|---|---|---|
| `pi-nvidia` | `pi --api-key "$NVIDIA_API_KEY"` | Lance Pi avec la clé API NVIDIA, choix de modèle interactif. |
| `pinvidia` | `pi --model nvidia/nemotron-3-super-120b-a12b --api-key "$NVIDIA_API_KEY"` | Raccourci explicite vers Nemotron 3 Super 120B-A12B. |
| `pinvidia-ultra` | `pi --model nvidia/nemotron-3-ultra-550b-a55b --api-key "$NVIDIA_API_KEY"` | Raccourci explicite vers Nemotron 3 Ultra 550B-A55B. |
| `pideepseek` | `pi --model deepseek-ai/deepseek-v4-pro-0813 --api-key "$NVIDIA_API_KEY"` | Raccourci explicite vers DeepSeek V4 Pro (0813). |

---

## 2. Agents sans tmux

[↑ Sommaire](#sommaire)

Ces alias lancent l'agent directement dans le terminal courant, sans le passer par tmux. Si tu fermes le terminal, l'onglet WezTerm ou la connexion SSH, l'agent s'arrête.

| Alias | Commande | Description |
|---|---|---|
| `cc` | `claude --dangerously-skip-permissions` | Agent de code existant, lancé directement. |
| `oc` | `opencode` | Agent de code existant, lancé directement. |
| `cc-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama launch claude` | Claude, backend macpro, direct dans le terminal. |
| `oc-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama launch opencode` | OpenCode, backend macpro, direct dans le terminal. |
| `cc-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama launch claude` | Claude, backend Taichi, direct dans le terminal. |
| `oc-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama launch opencode` | OpenCode, backend Taichi, direct dans le terminal. |
| `pi-nvidia` | `pi --api-key "$NVIDIA_API_KEY"` | Pi via NVIDIA cloud, direct dans le terminal. |

---

## 3. Agents avec tmux

[↑ Sommaire](#sommaire)

Sessions persistantes toujours accessibles depuis ton Samsung. L'agent continue de tourner même après une déconnexion.

Créer/ouvrir une session :

```bash
tnew app-dev
tnew claude-taichi
tnew oc-taichi
```

Depuis Samsung :

```bash
tmls
tm app-dev
```

Dans tmux, `Ctrl+b` puis `d` détache sans arrêter les processus.

### 3.1 Lancer un agent persistant

| Alias | Commande | Description |
|---|---|---|
| `cc-tmux-macpro` | `tmux new-session -A -s claude-macpro "OLLAMA_HOST=http://macpro:11434 ollama launch claude"` | Claude Code + backend macpro, dans tmux. |
| `cc-tmux-taichi` | `tmux new-session -A -s claude-taichi "OLLAMA_HOST=http://taichi:11434 ollama launch claude"` | Claude Code + backend Taichi, dans tmux. |
| `oc-tmux-macpro` | `tmux new-session -A -s opencode-macpro "OLLAMA_HOST=http://macpro:11434 ollama launch opencode"` | OpenCode + backend macpro, dans tmux. |
| `oc-tmux-taichi` | `tmux new-session -A -s opencode-taichi "OLLAMA_HOST=http://taichi:11434 ollama launch opencode"` | OpenCode + backend Taichi, dans tmux. |

### 3.2 Gérer les sessions tmux

| Alias | Commande | Description |
|---|---|---|
| `tnew` | `tmux new-session -A -s` | Crée une session tmux nommée, ou s'y attache si elle existe déjà. Usage : `tnew <session-name>`. |
| `tmls` | `tmux ls` | Liste toutes les sessions tmux persistantes. |
| `tm` | `tmux attach-session -d -t` | Prend une session nommée sur ce terminal ; la détache d'un autre terminal d'abord. Usage : `tm <session-name>`. |
| `tmwatch` | `tmux attach-session -t` | Attache sans retirer la session à un autre terminal. Pour observation. Usage : `tmwatch <session-name>`. |
| `tkill` | `tmux kill-session -t` | Tue une session et tous les programmes qui tournent dedans. Usage : `tkill <session-name>`. |
| `tname` | `tmux display-message -p '#S'` | Affiche le nom de la session tmux courante. |
| `twindows` | `tmux list-windows -a` | Liste toutes les fenêtres/onglets tmux, toutes sessions confondues. |
| `tclients` | `tmux list-clients` | Liste les clients attachés aux sessions tmux. |
| `treload` | `tmux source-file ~/.tmux.conf` | Recharge une future config `~/.tmux.conf`. |

---

## 4. Raccourcis clavier tmux

[↑ Sommaire](#sommaire)

Préfixe par défaut : `Ctrl+b`. Appuie sur `Ctrl+b`, relâche, puis appuie sur la touche indiquée.

### Sessions

| Raccourci | Action |
|---|---|
| `Ctrl+b` puis `d` | Détache la session courante sans arrêter les processus. |
| `Ctrl+b` puis `s` | Liste les sessions et permet d'en changer. |
| `Ctrl+b` puis `$` | Renomme la session courante. |

### Fenêtres

| Raccourci | Action |
|---|---|
| `Ctrl+b` puis `c` | Crée une nouvelle fenêtre. |
| `Ctrl+b` puis `n` | Fenêtre suivante. |
| `Ctrl+b` puis `p` | Fenêtre précédente. |
| `Ctrl+b` puis `0` à `9` | Va à la fenêtre numéro indiqué. |
| `Ctrl+b` puis `,` | Renomme la fenêtre courante. |
| `Ctrl+b` puis `&` | Ferme la fenêtre courante, avec confirmation. |
| `Ctrl+b` puis `w` | Liste les fenêtres. |

### Panneaux

| Raccourci | Action |
|---|---|
| `Ctrl+b` puis `%` | Split vertical, gauche/droite. |
| `Ctrl+b` puis `"` | Split horizontal, haut/bas. |
| `Ctrl+b` puis flèche | Se déplace vers le panneau dans cette direction. |
| `Ctrl+b` puis `x` | Ferme le panneau courant, avec confirmation. |
| `Ctrl+b` puis `z` | Zoom/dézoom le panneau courant. |
| `Ctrl+b` puis `q` | Affiche brièvement les numéros des panneaux. |

### Copie et défilement

| Raccourci | Action |
|---|---|
| `Ctrl+b` puis `[` | Entre en mode copie/défilement. |
| `q` | Quitte le mode copie. |
| `Espace` | Démarre une sélection en mode copie. |
| `Entrée` | Copie la sélection dans le buffer. |
| `Ctrl+b` puis `]` | Colle le dernier buffer copié. |

### Divers

| Raccourci | Action |
|---|---|
| `Ctrl+b` puis `:` | Ligne de commande tmux. |
| `Ctrl+b` puis `?` | Liste tous les raccourcis tmux. |

---

## 5. Raccourcis clavier WezTerm

[↑ Sommaire](#sommaire)

### Fenêtres et onglets

| Raccourci | Action |
|---|---|
| `CMD+t` | Nouvel onglet. |
| `CMD+n` | Nouvelle fenêtre. |
| `CMD+w` | Ferme l'onglet/panneau courant, avec confirmation. |
| `CMD+Shift+w` | Ferme la fenêtre courante, avec confirmation. |

### Souris

| Raccourci | Action |
|---|---|
| `CMD` + clic gauche + glisser | Déplace la fenêtre WezTerm. |

### Apparence

- Thème : `rose-pine-moon`
- Police : `Hack Nerd Font`, taille 15
- Opacité du fond : 0.8
- Flou du fond sur macOS : 50
- Barre d'onglets masquée s'il n'y a qu'un seul onglet
- Décorations de fenêtre : `RESIZE` uniquement
- Fenêtre non focalisée : texte assombri (`foreground_text_hsb` avec saturation 0.25, luminosité 0.45) et opacité réduite à 0.62, pour repérer d'un coup d'œil la fenêtre active.

---

## 6. Raccourcis clavier Neovim

[↑ Sommaire](#sommaire)

### Basique

| Raccourci | Mode | Action |
|---|---|---|
| `Échap` | Normal | Sauvegarde (`:update`). |
| `Ctrl+s` | Normal, Insertion, Visuel | Sauvegarde (`:update`). |
| `Ctrl+a` | Normal | Sélectionne tout (`ggVG`). |
| `p` sur une sélection | Visuel | Colle sans perdre le contenu du clipboard. |

### Fichiers / buffers

| Raccourci | Mode | Action |
|---|---|---|
| `<leader>w` | Normal | Sauvegarde (`:write`). |
| `<leader>q` | Normal | Quitte (`:quit`). |
| `<leader>x` | Normal | Ferme le buffer (`:bdelete`). |
| `<leader>bn` | Normal | Buffer suivant (`:bnext`). |
| `<leader>bp` | Normal | Buffer précédent (`:bprevious`). |

### Fenêtres

| Raccourci | Mode | Action |
|---|---|---|
| `Ctrl+h` | Normal | Se déplace vers la fenêtre de gauche. |
| `Ctrl+l` | Normal | Se déplace vers la fenêtre de droite. |
| `Ctrl+j` | Normal | Se déplace vers la fenêtre du bas. |
| `Ctrl+k` | Normal | Se déplace vers la fenêtre du haut. |
| `<leader>sv` | Normal | Split vertical (`:vsplit`). |
| `<leader>sh` | Normal | Split horizontal (`:split`). |
| `<leader>sx` | Normal | Ferme le split (`:close`). |

### LSP

| Raccourci | Mode | Action |
|---|---|---|
| `gd` | Normal | Va à la définition. |
| `gD` | Normal | Va à la déclaration. |
| `gr` | Normal | Références. |
| `gi` | Normal | Va à l'implémentation. |
| `K` | Normal | Documentation au survol (hover). |
| `<leader>rn` | Normal | Renomme le symbole. |
| `<leader>ca` | Normal, Visuel | Actions de code. |
| `<leader>ld` | Normal | Diagnostics de la ligne (float). |
| `[d` | Normal | Diagnostic précédent. |
| `]d` | Normal | Diagnostic suivant. |

### Terminal

| Raccourci | Mode | Action |
|---|---|---|
| `<leader>t` | Normal | Ouvre un terminal (`:terminal`). |

---

## 7. Raccourcis clavier macOS

[↑ Sommaire](#sommaire)

### Applications et fenêtres

| Raccourci | Action |
|---|---|
| `CMD+Espace` | Ouvre Spotlight. |
| `CMD+Tab` | Passe à l'application suivante. |
| `CMD+Shift+Tab` | Passe à l'application précédente. |
| `CMD+W` | Ferme la fenêtre ou l'onglet actif. |
| `CMD+Q` | Quitte l'application active. |
| `CMD+H` | Masque l'application active. |
| `CMD+Option+H` | Masque toutes les autres applications. |
| `CMD+M` | Réduit la fenêtre active dans le Dock. |
| `CMD+Option+M` | Réduit toutes les fenêtres de l'application active. |
| `Ctrl+Flèche bas` | Mission Control. |
| `Ctrl+Flèche haut` | Affiche les fenêtres de l'application active. |
| `Ctrl+Flèche gauche/droite` | Change d'espace (bureau). |
| `Ctrl+CMD+F` | Active/quitte le plein écran. |

### Navigation clavier

| Raccourci | Action |
|---|---|
| `Tab` | Contrôle suivant. |
| `Shift+Tab` | Contrôle précédent. |
| `Espace` | Active le contrôle sélectionné. |
| `Entrée` | Valide l'action ou ouvre l'élément sélectionné. |
| `Échap` | Annule/ferme le menu ou la boîte de dialogue. |
| `Ctrl+F2` | Focus sur la barre des menus. |
| `Ctrl+F3` | Focus sur le Dock. |
| `Ctrl+F4` | Fenêtre suivante de l'application active. |
| `Ctrl+F7` | Active/désactive la navigation complète au clavier. |
| `Ctrl+F8` | Focus sur les menus de statut. |

> Sur MacBook, ajoute `Fn` aux touches `F1` à `F12` selon les réglages clavier.

### Finder et fichiers

| Raccourci | Action |
|---|---|
| `CMD+N` | Nouvelle fenêtre Finder. |
| `CMD+T` | Nouvel onglet Finder. |
| `CMD+Flèche haut` | Dossier parent. |
| `CMD+Flèche bas` | Ouvre le fichier/dossier sélectionné. |
| `CMD+[` | Emplacement précédent. |
| `CMD+]` | Emplacement suivant. |
| `CMD+Shift+G` | Aller au dossier. |
| `CMD+Shift+H` | Dossier personnel. |
| `CMD+Shift+D` | Bureau. |
| `CMD+Shift+O` | Documents. |
| `CMD+Shift+U` | Utilitaires. |
| `CMD+Shift+.` | Affiche/masque les fichiers cachés. |
| `Espace` | Aperçu rapide. |
| `Entrée` | Renomme l'élément sélectionné. |
| `CMD+Suppr` | Envoie à la Corbeille. |
| `CMD+Shift+Suppr` | Vide la Corbeille, avec confirmation. |
| `CMD+D` | Duplique l'élément. |
| `CMD+I` | Informations sur l'élément. |
| `CMD+1` | Vue en icônes. |
| `CMD+2` | Vue en liste. |
| `CMD+3` | Vue en colonnes. |
| `CMD+4` | Vue en galerie. |

### Édition de texte

| Raccourci | Action |
|---|---|
| `CMD+C` | Copie. |
| `CMD+X` | Coupe. |
| `CMD+V` | Colle. |
| `CMD+Z` | Annule. |
| `CMD+Shift+Z` | Rétablit. |
| `CMD+A` | Sélectionne tout. |
| `CMD+F` | Recherche. |
| `CMD+G` | Résultat suivant. |
| `CMD+Shift+G` | Résultat précédent. |
| `CMD+S` | Enregistre. |
| `CMD+P` | Imprime. |
| `CMD+Flèche gauche/droite` | Début/fin de ligne. |
| `Option+Flèche gauche/droite` | Déplace le curseur d'un mot. |
| `Shift+Flèche` | Étend la sélection. |
| `Option+Shift+Flèche gauche/droite` | Étend la sélection d'un mot. |
| `CMD+Shift+Flèche gauche/droite` | Sélectionne jusqu'au début/fin de ligne. |
| `CMD+Flèche haut/bas` | Début/fin du document. |
| `Option+Suppr` | Supprime le mot précédent. |
| `Fn+Suppr` | Supprime vers l'avant. |
| `CMD+Suppr` | Supprime jusqu'au début de la ligne. |

### Captures d'écran

| Raccourci | Action |
|---|---|
| `CMD+Shift+3` | Capture l'écran entier. |
| `CMD+Shift+4` | Capture une zone ; `Espace` pour capturer une fenêtre. |
| `CMD+Shift+5` | Outils de capture et d'enregistrement. |
| `CMD+Shift+6` | Capture la Touch Bar, si disponible. |
| Ajoute `Ctrl` | Copie la capture dans le presse-papiers au lieu de l'enregistrer. |

### Veille, verrouillage, alimentation

| Raccourci | Action |
|---|---|
| `Ctrl+CMD+Q` | Verrouille l'écran immédiatement. |
| `CMD+Option+Éjecter` | Met le Mac en veille immédiatement, si touche Éjecter présente. |
| `CMD+Option+Touch ID` | Met le Mac en veille immédiatement, sur MacBook avec Touch ID. |
| `Ctrl+Shift+Bouton d'alimentation` | Met uniquement l'écran en veille. |
| `Ctrl+CMD+Bouton d'alimentation` | Redémarre, avec confirmation éventuelle. |
| `Ctrl+Option+CMD+Bouton d'alimentation` | Éteint, avec confirmation éventuelle. |
| Maintenir le bouton d'alimentation | Force l'arrêt, en cas de blocage uniquement. |

### Réglages rapides

| Raccourci | Action |
|---|---|
| `CMD+,` | Réglages de l'application active. |
| `Option+clic` sur Wi-Fi/Bluetooth/son/batterie | Options supplémentaires dans la barre des menus. |
| `Option+Luminosité` | Réglages d'écran directement. |
| `Option+Volume` | Réglages audio directement. |
| `Option+Clavier` | Réglages clavier directement. |

---

## 8. Routine rapide

[↑ Sommaire](#sommaire)

```bash
# Agent sans tmux — s'arrête si le terminal se ferme
cc-taichi
oc-macpro
pi-nvidia

# Agent avec tmux — continue après déconnexion
cc-tmux-taichi
oc-tmux-macpro

# Session de développement persistante
tnew app-dev
tmls
tm app-dev

# Modèle sur Taichi
ol-taichi pull <nom-du-modèle>
ol-taichi run <nom-du-modèle>

# Arrêt définitif d'une session
tkill app-dev
```

```text
Dans tmux : Ctrl+b, puis d  →  détache sans arrêter les processus
WezTerm   : CMD+t  →  nouvel onglet
Neovim    : <leader>w  →  sauvegarde ; gd  →  définition
macOS     : CMD+Espace  →  Spotlight ; Ctrl+CMD+Q  →  verrouiller l'écran
```