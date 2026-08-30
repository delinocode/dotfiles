# Référence complète — Zsh, tmux, WezTerm, Neovim et macOS

> **Navigation :** [Alias Zsh](#alias-zsh) · [tmux](#raccourcis-tmux) · [WezTerm](#raccourcis-wezterm) · [Neovim](#raccourcis-neovim) · [macOS](#raccourcis-macos) · [Routine rapide](#routine-rapide)

Ce document regroupe les alias Zsh, les raccourcis tmux, WezTerm, Neovim et les principaux raccourcis clavier macOS.

---

## Sommaire

- [Alias Zsh](#alias-zsh)
- [Raccourcis tmux](#raccourcis-tmux)
- [Raccourcis WezTerm](#raccourcis-wezterm)
- [Raccourcis Neovim](#raccourcis-neovim)
- [Raccourcis macOS](#raccourcis-macos)
- [Routine rapide](#routine-rapide)

---

## Alias Zsh

[Retour au sommaire](#sommaire)

### Navigation et fichiers

| Alias | Commande | Description |
|---|---|---|
| `..` | `cd ..` | Remonte d’un niveau dans l’arborescence. |
| `ll` | `eza -la` | Liste détaillée des fichiers avec `eza`. |
| `cat` | `bat` | Affiche un fichier avec coloration syntaxique. |

### Git

| Alias | Commande | Description |
|---|---|---|
| `add` | `git add .` | Ajoute tous les fichiers modifiés au staging. |
| `push` | `git push` | Envoie les commits vers le dépôt distant. |
| `pull` | `git pull` | Récupère et intègre les changements du dépôt distant. |
| `gs` | `git status` | Affiche l’état du dépôt Git. |
| `lg` | `lazygit` | Lance l’interface terminal Lazygit. |
| `m` | `git switch main` | Bascule sur la branche `main`. |

### Éditeur

| Alias | Commande | Description |
|---|---|---|
| `v` | `nvim` | Ouvre Neovim. |
| `vi` | `nvim` | Ouvre Neovim via la commande habituelle `vi`. |

### Agents de code

| Alias | Commande | Description |
|---|---|---|
| `cc` | `claude --dangerously-skip-permissions` | Lance Claude Code en mode permissif. |
| `oc` | `opencode` | Lance OpenCode. |

### Ollama — accès direct via Tailscale

La variable `OLLAMA_HOST` par défaut pointe vers `http://macpro:11434`.

| Alias | Commande | Description |
|---|---|---|
| `ol` | `ollama` | Lance Ollama avec le serveur par défaut (`macpro`). |
| `ol-list` | `ollama list` | Liste les modèles du serveur par défaut. |
| `ol-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama` | Utilise directement Ollama sur macpro. |
| `ol-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama` | Utilise directement Ollama sur Taichi. |
| `cc-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama launch claude` | Lance Claude avec macpro comme backend. |
| `oc-macpro` | `OLLAMA_HOST="http://macpro:11434" ollama launch opencode` | Lance OpenCode avec macpro comme backend. |
| `cc-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama launch claude` | Lance Claude avec Taichi comme backend. |
| `oc-taichi` | `OLLAMA_HOST="http://taichi:11434" ollama launch opencode` | Lance OpenCode avec Taichi comme backend. |

#### Gestion des modèles Taichi

```bash
# Lister les modèles installés sur Taichi
ol-taichi list

# Télécharger un modèle sur Taichi
ol-taichi pull <nom-du-modèle>

# Exécuter un modèle sur Taichi
ol-taichi run <nom-du-modèle>

# Supprimer un modèle de Taichi
ol-taichi rm <nom-du-modèle>

# Voir les modèles actifs sur Taichi
ol-taichi ps
```

Exemple :

```bash
ol-taichi pull qwen3
ol-taichi run qwen3
```

### Claude Desktop via tunnels SSH

| Alias | Commande | Description |
|---|---|---|
| `ol-tunnels` | Ouvre les tunnels SSH vers macpro (port local 12435) et Taichi (port local 11436). | Lance les deux tunnels en arrière-plan. |
| `ol-stop-tunnels` | Ferme les deux tunnels SSH configurés. | Arrête uniquement les tunnels concernés. |
| `ol-local` | `OLLAMA_HOST="http://127.0.0.1:11434" ollama` | Utilise Ollama local sur le MacBook Air. |
| `ol-tunnel-macpro` | `OLLAMA_HOST="http://127.0.0.1:12435" ollama` | Utilise macpro à travers le tunnel SSH. |
| `ol-tunnel-taichi` | `OLLAMA_HOST="http://127.0.0.1:11436" ollama` | Utilise Taichi à travers le tunnel SSH. |
| `claude-local` | Définit `OLLAMA_HOST` sur le serveur local, redémarre Claude Desktop, puis l’ouvre. | Claude Desktop utilise les modèles locaux. |
| `claude-macpro` | Définit `OLLAMA_HOST` sur `127.0.0.1:12435`, redémarre Claude Desktop, puis l’ouvre. | Claude Desktop utilise macpro par tunnel SSH. |
| `claude-taichi` | Définit `OLLAMA_HOST` sur `127.0.0.1:11436`, redémarre Claude Desktop, puis l’ouvre. | Claude Desktop utilise Taichi par tunnel SSH. |

### Pi et NVIDIA

| Alias | Commande | Description |
|---|---|---|
| `pi-nvidia` | `pi --api-key "$NVIDIA_API_KEY"` | Lance Pi avec l’API NVIDIA ; choix du modèle dans Pi. |
| `pinvidia` | `pi --model nvidia/nemotron-3-super-120b-a12b --api-key "$NVIDIA_API_KEY"` | Lance Pi avec Nemotron 3 Super 120B. |
| `pinvidia-ultra` | `pi --model nvidia/nemotron-3-ultra-550b-a55b --api-key "$NVIDIA_API_KEY"` | Lance Pi avec Nemotron 3 Ultra 550B. |
| `pideepseek` | `pi --model deepseek-ai/deepseek-v4-pro-0813 --api-key "$NVIDIA_API_KEY"` | Lance Pi avec DeepSeek V4 Pro. |

### tmux — sessions persistantes

| Alias | Commande | Description |
|---|---|---|
| `cc-tmux-macpro` | Lance/attache la session `claude-macpro`. | Claude sur macpro dans tmux. |
| `cc-tmux-taichi` | Lance/attache la session `claude-taichi`. | Claude sur Taichi dans tmux. |
| `oc-tmux-macpro` | Lance/attache la session `opencode-macpro`. | OpenCode sur macpro dans tmux. |
| `oc-tmux-taichi` | Lance/attache la session `opencode-taichi`. | OpenCode sur Taichi dans tmux. |
| `tnew <nom>` | `tmux new-session -A -s <nom>` | Crée une session tmux ou s’y attache si elle existe déjà. |
| `tmls` | `tmux ls` | Liste toutes les sessions tmux. |
| `tm <nom>` | `tmux attach-session -d -t <nom>` | Attache la session au terminal courant et la détache des autres clients. |
| `tmwatch <nom>` | `tmux attach-session -t <nom>` | Attache sans forcer le détachement d’un autre client. |
| `tkill <nom>` | `tmux kill-session -t <nom>` | Supprime une session et arrête les programmes qu’elle contient. |
| `tname` | `tmux display-message -p '#S'` | Affiche le nom de la session tmux actuelle. |
| `twindows` | `tmux list-windows -a` | Liste les fenêtres de toutes les sessions tmux. |
| `tclients` | `tmux list-clients` | Liste les terminaux attachés à tmux. |
| `treload` | `tmux source-file ~/.tmux.conf` | Recharge `~/.tmux.conf` lorsqu’il existe. |

---

## Raccourcis tmux

[Retour au sommaire](#sommaire)

Préfixe tmux par défaut : `Ctrl+b`. Appuie d’abord sur `Ctrl+b`, relâche, puis appuie sur la touche suivante.

### Sessions

| Raccourci | Action |
|---|---|
| `Ctrl+b`, puis `d` | Détache la session courante sans arrêter les processus. |
| `Ctrl+b`, puis `s` | Affiche la liste des sessions et permet de changer de session. |
| `Ctrl+b`, puis `$` | Renomme la session courante. |

### Fenêtres

| Raccourci | Action |
|---|---|
| `Ctrl+b`, puis `c` | Crée une nouvelle fenêtre. |
| `Ctrl+b`, puis `n` | Va à la fenêtre suivante. |
| `Ctrl+b`, puis `p` | Va à la fenêtre précédente. |
| `Ctrl+b`, puis `0` à `9` | Va à la fenêtre portant ce numéro. |
| `Ctrl+b`, puis `,` | Renomme la fenêtre courante. |
| `Ctrl+b`, puis `&` | Ferme la fenêtre courante après confirmation. |
| `Ctrl+b`, puis `w` | Affiche la liste des fenêtres. |

### Panneaux

| Raccourci | Action |
|---|---|
| `Ctrl+b`, puis `%` | Crée un panneau vertical (gauche/droite). |
| `Ctrl+b`, puis `"` | Crée un panneau horizontal (haut/bas). |
| `Ctrl+b`, puis flèche | Passe au panneau dans la direction choisie. |
| `Ctrl+b`, puis `x` | Ferme le panneau courant après confirmation. |
| `Ctrl+b`, puis `z` | Zoom ou dézoom le panneau courant. |
| `Ctrl+b`, puis `q` | Affiche brièvement le numéro de chaque panneau. |

### Copie et défilement

| Raccourci | Action |
|---|---|
| `Ctrl+b`, puis `[` | Entre dans le mode copie et défilement. |
| `q` | Quitte le mode copie. |
| `Espace` | Commence une sélection dans le mode copie. |
| `Entrée` | Copie la sélection dans le buffer tmux. |
| `Ctrl+b`, puis `]` | Colle le dernier buffer tmux. |

### Aide et commandes

| Raccourci | Action |
|---|---|
| `Ctrl+b`, puis `:` | Ouvre la ligne de commande tmux. |
| `Ctrl+b`, puis `?` | Affiche tous les raccourcis tmux. |

---

## Raccourcis WezTerm

[Retour au sommaire](#sommaire)

Ta configuration utilise principalement la touche `Commande` (`CMD`).

| Raccourci | Action |
|---|---|
| `CMD+t` | Crée un nouvel onglet. |
| `CMD+n` | Crée une nouvelle fenêtre WezTerm. |
| `CMD+w` | Ferme l’onglet ou le panneau courant, avec confirmation. |
| `CMD+Shift+w` | Ferme la fenêtre courante, avec confirmation. |
| `CMD + clic gauche + glisser` | Déplace la fenêtre WezTerm. |

### Apparence WezTerm

- Thème : `rose-pine-moon`
- Police : `Hack Nerd Font`, taille 15
- Opacité de la fenêtre active : 0,8
- Flou macOS : 50
- Barre d’onglets cachée lorsqu’il n’y a qu’un seul onglet
- Fenêtres non actives : texte plus sombre et opacité réduite à 0,62

---

## Raccourcis Neovim

[Retour au sommaire](#sommaire)

`<leader>` correspond souvent à `Espace`, mais vérifie ta configuration si tu l’as changé ailleurs.

### Général

| Raccourci | Mode | Action |
|---|---|---|
| `Échap` | Normal | Sauvegarde le fichier si nécessaire (`:update`). |
| `Ctrl+s` | Normal, insertion, visuel | Sauvegarde le fichier si nécessaire (`:update`). |
| `Ctrl+a` | Normal | Sélectionne tout le fichier (`ggVG`). |
| `p` sur une sélection | Visuel | Colle sans perdre le contenu précédemment copié. |

### Fichiers et buffers

| Raccourci | Mode | Action |
|---|---|---|
| `<leader>w` | Normal | Sauvegarde (`:write`). |
| `<leader>q` | Normal | Quitte (`:quit`). |
| `<leader>x` | Normal | Ferme le buffer (`:bdelete`). |
| `<leader>bn` | Normal | Passe au buffer suivant (`:bnext`). |
| `<leader>bp` | Normal | Passe au buffer précédent (`:bprevious`). |

### Fenêtres et splits

| Raccourci | Mode | Action |
|---|---|---|
| `Ctrl+h` | Normal | Va à la fenêtre de gauche. |
| `Ctrl+l` | Normal | Va à la fenêtre de droite. |
| `Ctrl+j` | Normal | Va à la fenêtre du bas. |
| `Ctrl+k` | Normal | Va à la fenêtre du haut. |
| `<leader>sv` | Normal | Crée un split vertical (`:vsplit`). |
| `<leader>sh` | Normal | Crée un split horizontal (`:split`). |
| `<leader>sx` | Normal | Ferme le split courant (`:close`). |

### LSP et diagnostics

| Raccourci | Mode | Action |
|---|---|---|
| `gd` | Normal | Va à la définition. |
| `gD` | Normal | Va à la déclaration. |
| `gr` | Normal | Liste les références. |
| `gi` | Normal | Va à l’implémentation. |
| `K` | Normal | Affiche la documentation au survol. |
| `<leader>rn` | Normal | Renomme le symbole sous le curseur. |
| `<leader>ca` | Normal, visuel | Ouvre les actions de code. |
| `<leader>ld` | Normal | Affiche les diagnostics de la ligne. |
| `[d` | Normal | Va au diagnostic précédent. |
| `]d` | Normal | Va au diagnostic suivant. |

### Terminal intégré

| Raccourci | Mode | Action |
|---|---|---|
| `<leader>t` | Normal | Ouvre un terminal intégré (`:terminal`). |

---

## Raccourcis macOS

[Retour au sommaire](#sommaire)

`CMD` signifie Commande, `Option` signifie Alt et `Ctrl` signifie Contrôle.

### Applications et fenêtres

| Raccourci | Action |
|---|---|
| `CMD+Espace` | Ouvre Spotlight pour chercher une app, un fichier, un réglage ou faire un calcul. |
| `CMD+Tab` | Passe à l’application suivante. Maintiens `CMD` et utilise les flèches pour choisir une app. |
| `CMD+Shift+Tab` | Passe à l’application précédente. |
| `CMD+W` | Ferme la fenêtre ou l’onglet actif. |
| `CMD+Q` | Quitte complètement l’application active. |
| `CMD+H` | Masque l’application active. |
| `CMD+Option+H` | Masque toutes les autres applications. |
| `CMD+M` | Réduit la fenêtre active dans le Dock. |
| `CMD+Option+M` | Réduit toutes les fenêtres de l’application active. |
| `Ctrl+Flèche bas` | Affiche Mission Control. |
| `Ctrl+Flèche haut` | Affiche les fenêtres de l’application active. |
| `Ctrl+Flèche gauche/droite` | Passe à l’espace (bureau) précédent ou suivant. |
| `Ctrl+CMD+F` | Active ou quitte le plein écran. |

### Navigation clavier générale

| Raccourci | Action |
|---|---|
| `Tab` | Passe au contrôle suivant : bouton, champ ou élément interactif. |
| `Shift+Tab` | Revient au contrôle précédent. |
| `Espace` | Active le bouton, la case ou l’élément sélectionné. |
| `Entrée` | Valide une action, ouvre l’élément sélectionné ou confirme une boîte de dialogue. |
| `Échap` | Annule ou ferme la boîte de dialogue ou le menu actif. |
| `Ctrl+F2` | Place le focus sur la barre des menus. |
| `Ctrl+F3` | Place le focus sur le Dock. |
| `Ctrl+F4` | Passe à la fenêtre suivante de l’application active. |
| `Ctrl+F7` | Active ou désactive la navigation complète au clavier. |
| `Ctrl+F8` | Place le focus sur les menus de statut de la barre des menus. |

> Sur un MacBook, il peut être nécessaire d’ajouter `Fn` aux raccourcis `F1` à `F12`, selon les réglages du clavier.

### Finder et fichiers

| Raccourci | Action |
|---|---|
| `CMD+N` | Ouvre une nouvelle fenêtre Finder. |
| `CMD+T` | Ouvre un nouvel onglet Finder. |
| `CMD+W` | Ferme la fenêtre ou l’onglet Finder actif. |
| `CMD+Flèche haut` | Ouvre le dossier parent. |
| `CMD+Flèche bas` | Ouvre le fichier ou dossier sélectionné. |
| `CMD+[` | Revient à l’emplacement précédent. |
| `CMD+]` | Avance vers l’emplacement suivant. |
| `CMD+Shift+G` | Ouvre « Aller au dossier ». |
| `CMD+Shift+H` | Ouvre le dossier personnel. |
| `CMD+Shift+D` | Ouvre le Bureau. |
| `CMD+Shift+O` | Ouvre le dossier Documents. |
| `CMD+Shift+U` | Ouvre le dossier Utilitaires. |
| `CMD+Shift+.` | Affiche ou masque les fichiers cachés. |
| `Espace` | Ouvre l’Aperçu rapide du fichier sélectionné. |
| `Entrée` | Renomme le fichier sélectionné. |
| `CMD+Suppr` | Place l’élément sélectionné dans la Corbeille. |
| `CMD+Shift+Suppr` | Vide la Corbeille avec confirmation. |
| `CMD+D` | Duplique l’élément sélectionné. |
| `CMD+I` | Affiche les informations de l’élément sélectionné. |
| `CMD+1` | Affichage par icônes. |
| `CMD+2` | Affichage en liste. |
| `CMD+3` | Affichage en colonnes. |
| `CMD+4` | Affichage en galerie. |

### Édition de texte

| Raccourci | Action |
|---|---|
| `CMD+C` | Copie. |
| `CMD+X` | Coupe. |
| `CMD+V` | Colle. |
| `CMD+Z` | Annule. |
| `CMD+Shift+Z` | Rétablit. |
| `CMD+A` | Sélectionne tout. |
| `CMD+F` | Recherche dans l’application active. |
| `CMD+G` | Résultat suivant de la recherche. |
| `CMD+Shift+G` | Résultat précédent de la recherche. |
| `CMD+S` | Enregistre. |
| `CMD+P` | Imprime. |
| `CMD+Flèche gauche` | Va au début de la ligne. |
| `CMD+Flèche droite` | Va à la fin de la ligne. |
| `Option+Flèche gauche/droite` | Déplace le curseur d’un mot. |
| `Shift+Flèche` | Étend la sélection. |
| `Option+Shift+Flèche gauche/droite` | Étend la sélection d’un mot. |
| `CMD+Shift+Flèche gauche/droite` | Sélectionne jusqu’au début ou à la fin de la ligne. |
| `CMD+Flèche haut` | Va au début du document. |
| `CMD+Flèche bas` | Va à la fin du document. |
| `Option+Suppr` | Supprime le mot précédent. |
| `Fn+Suppr` | Supprime vers l’avant. |
| `CMD+Suppr` | Supprime jusqu’au début de la ligne. |

### Captures d’écran et enregistrement

| Raccourci | Action |
|---|---|
| `CMD+Shift+3` | Capture l’écran entier. |
| `CMD+Shift+4` | Capture une zone sélectionnée ; appuie sur `Espace` pour capturer une fenêtre. |
| `CMD+Shift+5` | Ouvre les outils de capture et d’enregistrement d’écran. |
| `CMD+Shift+6` | Capture la Touch Bar, si disponible. |
| Ajoute `Ctrl` | Copie la capture dans le presse-papiers au lieu de l’enregistrer dans un fichier. |

### Veille, verrouillage et alimentation

| Raccourci | Action |
|---|---|
| `Ctrl+CMD+Q` | Verrouille immédiatement l’écran. |
| `CMD+Option+Éjecter` | Met immédiatement le Mac en veille, si une touche Éjecter est présente. |
| `CMD+Option+Touch ID` | Met immédiatement le Mac en veille sur un MacBook avec Touch ID. |
| `Ctrl+Shift+Bouton d’alimentation` | Met uniquement l’écran en veille. |
| `Ctrl+CMD+Bouton d’alimentation` | Redémarre le Mac après confirmation éventuelle. |
| `Ctrl+Option+CMD+Bouton d’alimentation` | Éteint le Mac après confirmation éventuelle. |
| Maintenir le bouton d’alimentation | Force l’arrêt ; à utiliser uniquement si le Mac est bloqué. |

### Réglages rapides

| Raccourci | Action |
|---|---|
| `CMD+,` | Ouvre les réglages de l’application active, si elle utilise ce raccourci. |
| `Option+clic` sur Wi-Fi, Bluetooth, son ou batterie dans la barre des menus | Affiche des informations et options supplémentaires. |
| `Option+Luminosité` | Ouvre directement les réglages d’écran. |
| `Option+Volume` | Ouvre directement les réglages audio. |
| `Option+Clavier` | Ouvre directement les réglages clavier. |

---

## Routine rapide

[Retour au sommaire](#sommaire)

```bash
# Créer ou reprendre une session de développement persistante
tnew app-dev

# Lancer Claude dans tmux avec Taichi
cc-tmux-taichi

# Lister les sessions tmux
tmls

# Reprendre une session depuis le MacBook Air ou Samsung
tm app-dev

# Télécharger et utiliser un modèle sur Taichi
ol-taichi pull <nom-du-modèle>
ol-taichi run <nom-du-modèle>

# Détruire une session et ses programmes
tkill app-dev
```

```text
Dans tmux : Ctrl+b, puis d  →  détache la session sans arrêter les processus.
Dans WezTerm : CMD+t  →  nouvel onglet.
Dans Neovim : <leader>w  →  sauvegarde ; gd  →  définition.
Dans macOS : CMD+Espace  →  Spotlight ; Ctrl+CMD+Q  →  verrouiller l’écran.
```