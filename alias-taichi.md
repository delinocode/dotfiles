# Alias Taichi — endpoints IA et tmux

Ce document est la référence unique pour travailler depuis **Taichi** avec les trois backends :

- **Taichi Ollama local** : `http://127.0.0.1:11434`
- **MacBook Pro Ollama** : `http://macpro:11434`
- **MacBook Pro MLX Serve** : `http://macpro:11234`

`macpro` doit être résolu par Tailscale/MagicDNS. Les commandes MacBook Pro fonctionnent seulement lorsque le MacBook Pro et le service correspondant sont allumés.

## Vérifier les endpoints

```zsh
ol-list                 # modèles Ollama locaux Taichi
ol-taichi-list          # même endpoint local
ol-macpro-list          # Ollama natif MacBook Pro
mlx-health              # santé MLX Serve MacBook Pro
mlx-models              # modèles MLX Serve MacBook Pro
```

Pour Taichi, les modèles actuellement attendus sont notamment :

```text
qwen3.8:27b-q8_0
nemotron-3.5-lightning:30b-a3b
```

## Pi

| Backend | Commande directe | Session tmux persistante |
|---|---|---|
| Taichi Ollama | `pi-taichi` | `pi-tmux-taichi` |
| MacBook Pro Ollama | `pi-macpro` | `pi-tmux-macpro` |
| MacBook Pro MLX Serve | `pi-mlx-macpro` | `pi-tmux-mlx-macpro` |

Pi permet de choisir ou changer de modèle depuis son interface avec `/model`.

## Claude Code

| Backend | Commande directe | Session tmux persistante |
|---|---|---|
| Taichi Ollama | `cc-taichi` | `cc-tmux-taichi` |
| MacBook Pro Ollama | `cc-macpro` | `cc-tmux-macpro` |
| MacBook Pro MLX Serve | `cc-mlx-macpro` | `cc-tmux-mlx-macpro` |

Ces aliases passent par `ollama launch claude`, afin d'utiliser le workflow Ollama configuré plutôt que de démarrer Claude Code directement en mode connexion Anthropic.

## OpenCode

| Backend | Commande directe | Session tmux persistante |
|---|---|---|
| Taichi Ollama | `oc-taichi` | `oc-tmux-taichi` |
| MacBook Pro Ollama | `oc-macpro` | `oc-tmux-macpro` |
| MacBook Pro MLX Serve | `oc-mlx-macpro` | `oc-tmux-mlx-macpro` |

## Sessions tmux

Les commandes `*-tmux-*` créent une session si elle n'existe pas ou s'y reconnectent si elle existe déjà.

```zsh
tmls                         # lister les sessions
tm claude-taichi             # reprendre une session
tm opencode-mlx-macpro       # reprendre une session
tkill pi-taichi              # arrêter une session
```

Pour détacher une session sans arrêter l'agent : appuie sur `Ctrl+b`, relâche, puis appuie sur `d`.

## Commandes Ollama directes

```zsh
ol-qwen                      # Qwen local Taichi
ol-nemotron                  # Nemotron local Taichi
ol-taichi run <modele>       # lancer n'importe quel modèle Taichi
ol-macpro run <modele>       # lancer un modèle Ollama MacBook Pro
```

## Après modification

```zsh
cd ~/dotfiles
bash rebuild.sh
```

Reconnecte-toi ensuite en SSH pour charger les aliases Zsh dans une nouvelle session.
