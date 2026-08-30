# Guide opérationnel — LLM distants, Ollama, Claude Code, Claude Desktop, OpenCode et Pi

Ce document est la référence de ton système actuel sur le **MacBook Air**. Il commence par les commandes réellement utiles au quotidien, puis explique l'architecture, les modèles, les tunnels SSH, les diagnostics, et termine par le `home.nix` complet.

Le but : tu peux donner ce document à une IA pour comprendre le système et mettre à jour ton application plus tard, sans casser les connexions existantes.

---

## 1. Commandes quotidiennes

### Voir les modèles sur chaque serveur

```bash
# macpro — connexion directe via Tailscale
ol-macpro list
ol-macpro ps

# taichi — connexion directe via Tailscale
ol-taichi list
ol-taichi ps

# MacBook Air — app Ollama locale, si des modèles locaux sont installés
ol-local list
ol-local ps
```

- `list` : modèles téléchargés sur le disque du serveur ciblé.
- `ps` : modèles réellement chargés en mémoire à l'instant présent.
- `ollama list` ou `ol-list` tout seuls visent **macpro**, car `OLLAMA_HOST` est défini globalement sur `http://macpro:11434`.

### Lancer un agent de code dans le terminal

```bash
# Claude Code via Ollama sur macpro
cc-macpro

# Claude Code via Ollama sur taichi
cc-taichi

# OpenCode via Ollama sur macpro
co-macpro

# OpenCode via Ollama sur taichi
co-taichi

# Claude Code natif Anthropic (pas Ollama)
cc

# Codex CLI natif
co

# Pi avec les providers NVIDIA
pi-nvidia
```

Lancer un modèle explicitement, sans modifier la config Nix :

```bash
# macpro
cc-macpro --model qwen3.8-flash-next:125b-mlx

# taichi
cc-taichi --model qwen3.8:27b-q8_0
cc-taichi --model nemotron-3.5-lightning:30b-a3b
```

Dans les interfaces :

```text
Pi       : /model ou Ctrl+L
OpenCode : /models
Claude   : --model nom-du-modele lorsque nécessaire
```

### Claude Desktop avec Ollama

Pour que l'app **Claude Desktop** puisse utiliser les modèles de macpro ou Taichi, il faut démarrer les tunnels une fois après un redémarrage du MacBook Air ou une perte de réseau :

```bash
ol-tunnels
```

Ensuite :

```bash
# Claude Desktop → modèles macpro
claude-macpro

# Claude Desktop → modèles Taichi
claude-taichi

# Claude Desktop → modèles locaux du MacBook Air
claude-local
```

Exemple : Claude Code dans le terminal sur Taichi et Claude Desktop sur macpro en même temps :

```bash
ol-tunnels
cc-taichi
claude-macpro
```

`cc-taichi` utilise Taichi directement, tandis que `claude-macpro` utilise le tunnel local vers macpro. Les deux peuvent tourner en même temps.

### Vérifier les tunnels Claude Desktop

```bash
ol-tunnel-macpro list
ol-tunnel-taichi list
```

Résultats attendus :

```text
# macpro
qwen3.8-flash-next:125b-mlx

# taichi
qwen3.8:27b-q8_0
nemotron-3.5-lightning:30b-a3b
```

Arrêter uniquement les tunnels locaux quand ils ne servent plus :

```bash
ol-stop-tunnels
```

Cette commande ne stoppe jamais Ollama sur macpro/Taichi et ne tue pas de génération distante. Elle ferme seulement les connexions SSH de tunnel sur le MacBook Air.

### Ajouter, tester ou supprimer un modèle

Ajouter un modèle sur **macpro** :

```bash
ssh maclino@macpro
ollama pull nom-du-modele
ollama list
exit
```

Ajouter un modèle sur **taichi** :

```bash
ssh delai@taichi
ollama pull nom-du-modele
ollama list
exit
```

Tester un modèle en chat simple :

```bash
OLLAMA_HOST="http://macpro:11434" ollama run qwen3.8-flash-next:125b-mlx
OLLAMA_HOST="http://taichi:11434" ollama run qwen3.8:27b-q8_0
```

Quitter un chat Ollama : `Ctrl + D` ou `/bye`.

Supprimer un modèle sur le serveur choisi :

```bash
ol-macpro rm nom-du-modele
ol-taichi rm nom-du-modele
```

Aucun rebuild Nix n'est requis pour télécharger, supprimer ou changer de modèle : les modèles sont gérés par les serveurs Ollama.

---

## 2. Tous les alias

| Alias | Ce qu'il fait | Cible | Tunnel requis |
|---|---|---|---|
| `ol` | Client Ollama par défaut | macpro | Non |
| `ol-list` | Liste les modèles par défaut | macpro | Non |
| `ol-macpro` | Client Ollama direct | macpro | Non |
| `cc-macpro` | Lance Claude Code via Ollama | macpro | Non |
| `co-macpro` | Lance OpenCode via Ollama | macpro | Non |
| `ol-taichi` | Client Ollama direct | taichi | Non |
| `cc-taichi` | Lance Claude Code via Ollama | taichi | Non |
| `co-taichi` | Lance OpenCode via Ollama | taichi | Non |
| `ol-local` | Client Ollama local | MacBook Air | Non |
| `ol-tunnels` | Lance deux tunnels SSH en fond | macpro + taichi | — |
| `ol-stop-tunnels` | Arrête les deux tunnels SSH locaux | local seulement | — |
| `ol-tunnel-macpro` | Client Ollama à travers le tunnel | macpro | Oui |
| `ol-tunnel-taichi` | Client Ollama à travers le tunnel | taichi | Oui |
| `claude-local` | Relance Claude Desktop | Ollama local | Non |
| `claude-macpro` | Relance Claude Desktop | macpro | Oui |
| `claude-taichi` | Relance Claude Desktop | taichi | Oui |
| `cc` | Lance Claude Code natif | Anthropic | Non |
| `co` | Lance Codex CLI natif | OpenAI/Codex | Non |
| `pi-nvidia` | Lance Pi | NVIDIA cloud | Non |
| `pinvidia` | Pi avec Nemotron Super 120B | NVIDIA cloud | Non |
| `pinvidia-ultra` | Pi avec Nemotron Ultra 550B | NVIDIA cloud | Non |
| `pideepseek` | Pi avec DeepSeek V4 Pro | NVIDIA cloud | Non |

Autres alias shell utiles :

```bash
v / vi       # neovim
ll           # eza -la
cat          # bat
add          # git add .
gs           # git status
lg           # lazygit
m            # git switch main
```

---

## 3. Architecture actuelle

```text
MacBook Air
  ├── Terminal, Neovim, Claude Code, OpenCode, Pi
  ├── Claude Desktop + app Ollama GUI
  ├── Application existante utilisant OLLAMA_HOST
  │
  ├── Tailscale direct → http://macpro:11434
  │       └── macpro : Mac Apple Silicon, 128 GB mémoire unifiée
  │             └── Ollama + qwen3.8-flash-next:125b-mlx (~104 GB)
  │
  ├── Tailscale direct → http://taichi:11434
  │       └── taichi : Ubuntu, 2× RTX 3090, 64 GB DDR5
  │             ├── qwen3.8:27b-q8_0 (~29 GB)
  │             └── nemotron-3.5-lightning:30b-a3b (~25 GB)
  │
  ├── App Ollama locale → 127.0.0.1:11434
  │       └── modèles locaux, seulement si tu en installes sur le MacBook Air
  │
  ├── Tunnels pour Claude Desktop
  │       ├── 127.0.0.1:12435 → macpro:11434
  │       └── 127.0.0.1:11436 → taichi:11434
  │
  └── Pi → NVIDIA Build/NIM via NVIDIA_API_KEY
```

Adresses Tailscale observées pendant les tests :

```text
macpro : 100.81.14.102
taichi : 100.68.8.80
```

Utilisateurs SSH :

```text
macpro : maclino
taichi : delai
```

Les modèles distants ne sont jamais téléchargés sur le MacBook Air. Le MacBook Air agit comme client : il envoie des prompts, reçoit les réponses et peut exécuter les outils locaux associés à ses agents.

---

## 4. OLLAMA_HOST : rôle et impact

Le système garde cette variable globale :

```text
OLLAMA_HOST=http://macpro:11434
```

Elle est définie par Home Manager et exportée par Zsh. Conséquence :

```bash
ollama list
ollama ps
ollama run nom-du-modele
```

visent **macpro** par défaut.

Cela est volontaire : ton application existante dépend de cette cible directe et ne doit pas être cassée.

Les alias explicites surchargent la variable uniquement pour une commande :

```bash
ol-taichi list
```

équivaut à :

```bash
OLLAMA_HOST="http://taichi:11434" ollama list
```

Les commandes `claude-macpro`, `claude-taichi` et `claude-local` utilisent `launchctl setenv` uniquement pour l'environnement de l'application GUI Claude Desktop relancée. Elles ne modifient pas `OLLAMA_HOST` dans ton terminal actuel ni dans ton application existante.

---

## 5. Claude Desktop et les tunnels SSH

### Pourquoi les tunnels sont nécessaires

Claude Desktop est une application graphique macOS. L'intégration Ollama dans l'app Ollama/Claude Desktop fonctionne avec un endpoint local. Les serveurs distants sont donc rendus locaux par des tunnels SSH :

```text
Claude Desktop / app Ollama locale
       ↓
127.0.0.1:12435
       ↓ tunnel SSH
macpro:11434
       ↓
modèle macpro
```

et :

```text
Claude Desktop / app Ollama locale
       ↓
127.0.0.1:11436
       ↓ tunnel SSH
taichi:11434
       ↓
modèle taichi
```

Les ports réservés sont :

```text
127.0.0.1:11434 = app Ollama locale
127.0.0.1:12435 = tunnel macpro
127.0.0.1:11436 = tunnel taichi
```

Le port `11435` ne doit plus être utilisé pour macpro : il a créé un conflit observé entre Ollama local (IPv4) et SSH (IPv6). Le port `12435` évite ce conflit.

### Activer l'intégration Ollama → Claude Desktop

Claude Desktop et l'app Ollama sont installés via les casks Homebrew gérés dans `configuration.nix` :

```nix
casks = [
  "wezterm"
  "claude-code"
  "claude"
  "ollama"
];
```

Dans l'app Ollama :

1. Ouvrir **Apps**.
2. Activer le toggle **Claude**.
3. Ouvrir **Settings** → **Apps** → **Claude**.
4. Sélectionner le modèle proposé par l'endpoint actuellement actif.
5. Cliquer sur **Restart Claude** si l'app le demande.

Pour revenir à la configuration Claude native :

```bash
ollama launch claude-desktop --restore
```

ou Ollama → **Apps** → Claude → **Off**.

### Utilisation simultanée

Tu peux faire tourner plusieurs choses à la fois. Exemple :

```bash
# Prépare les accès GUI distants
ol-tunnels

# Une session Claude Code en terminal sur Taichi
cc-taichi

# Claude Desktop avec macpro
claude-macpro
```

Cela ne télécharge pas deux modèles sur le MacBook Air. Chaque client envoie ses requêtes au serveur choisi.

### Ce que fait `ol-tunnels`

Il lance ces deux connexions en arrière-plan :

```bash
ssh -fN -L 127.0.0.1:12435:localhost:11434 maclino@macpro
ssh -fN -L 127.0.0.1:11436:localhost:11434 delai@taichi
```

- `-f` : SSH va en arrière-plan après authentification.
- `-N` : aucun shell distant, seulement le tunnel.
- `-L` : `adresse_locale:port_local` est redirigé vers `adresse_distante:port_distant` vu depuis la machine distante.

Un tunnel n'arrête pas, ne redémarre pas et ne modifie pas Ollama sur macpro ou taichi. Il est donc possible de le créer alors qu'un serveur est déjà en train d'exécuter une requête.

---

## 6. Modèles, mémoire et concurrence

### Modèles connus

| Machine | Modèle | Emplacement / rôle |
|---|---|---|
| macpro | `qwen3.8-flash-next:125b-mlx` | grand modèle MLX, ~104 GB sur disque |
| taichi | `qwen3.8:27b-q8_0` | modèle Qwen quantifié, ~29 GB |
| taichi | `nemotron-3.5-lightning:30b-a3b` | modèle Nemotron, ~25 GB |
| MacBook Air | aucun obligatoire | modèles locaux facultatifs |

### Plusieurs terminaux ne créent pas automatiquement plusieurs copies

Ouvrir plusieurs terminaux ou plusieurs agents sur le même serveur ne charge pas automatiquement une copie complète du même modèle par terminal :

```text
Terminal Air A ─┐
Terminal Air B ─┼──> même serveur Ollama ──> même modèle chargé
Terminal Air C ─┘
```

Chaque terminal a son historique/contexte de conversation, mais le serveur Ollama partage normalement le même modèle chargé en mémoire. La concurrence peut toutefois réduire la vitesse de chaque génération, mettre les requêtes en file, ou augmenter la mémoire liée au contexte.

Une copie additionnelle peut n'apparaître que dans des cas particuliers : modèles/tags différents actifs simultanément, runners séparés imposés par le serveur, ou contraintes de parallélisme et de contexte.

### Déchargement et observation

```bash
ol-macpro ps
ol-taichi ps
```

ou :

```bash
curl http://macpro:11434/api/ps | jq
curl http://taichi:11434/api/ps | jq
```

Après inactivité, Ollama peut décharger le modèle de la mémoire selon `keep_alive`. Il reste sur disque et apparaît toujours dans `ollama list`; la requête suivante le recharge.

Forcer le déchargement d'un modèle :

```bash
ol-macpro stop qwen3.8-flash-next:125b-mlx
ol-taichi stop qwen3.8:27b-q8_0
```

Surveiller Taichi :

```bash
watch -n 1 nvidia-smi
```

---

## 7. API pour ton application et autres outils

Pour une application ou un outil compatible OpenAI, les endpoints directs sont :

```text
macpro
Base URL : http://macpro:11434/v1
API key  : ollama
Model    : qwen3.8-flash-next:125b-mlx

Taichi
Base URL : http://taichi:11434/v1
API key  : ollama
Model    : qwen3.8:27b-q8_0
         ou nemotron-3.5-lightning:30b-a3b
```

Test API OpenAI-compatible :

```bash
curl http://macpro:11434/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "qwen3.8-flash-next:125b-mlx",
    "messages": [
      {
        "role": "user",
        "content": "Réponds seulement : connexion réussie"
      }
    ],
    "stream": false
  }' | jq
```

Pour les outils qui attendent une API Anthropic, la compatibilité Ollama peut être déclarée ainsi :

```bash
export ANTHROPIC_AUTH_TOKEN=ollama
export ANTHROPIC_BASE_URL="http://macpro:11434"
```

Ne modifie pas la variable globale `OLLAMA_HOST` de ton application pour les tunnels : elle doit rester sur `http://macpro:11434` tant que ton application actuelle s'appuie sur cette adresse.

---

## 8. Pi, NVIDIA et OpenCode

### Pi / NVIDIA

La clé est chargée par Zsh depuis :

```text
~/dotfiles/secrets/env
```

Format attendu :

```bash
export NVIDIA_API_KEY="nvapi-TA_CLE"
export NVIDIA_NIM_API_KEY="$NVIDIA_API_KEY"
```

Vérifier sans afficher la clé :

```bash
[[ -n "$NVIDIA_API_KEY" ]] && echo "NVIDIA OK" || echo "clé NVIDIA absente"
```

Lancer :

```bash
pi-nvidia
```

Puis choisir le modèle avec `/model` ou `Ctrl+L`.

Endpoint NVIDIA OpenAI-compatible :

```text
https://integrate.api.nvidia.com/v1
```

### Déclarer macpro et Taichi dans Pi

Le fichier source versionné est :

```text
~/dotfiles/home/.pi/agent/models.json
```

Home Manager le lie vers :

```text
~/.pi/agent/models.json
```

Exemple de structure pour exposer les deux serveurs Ollama :

```json
{
  "providers": {
    "ollama-macpro": {
      "baseUrl": "http://macpro:11434/v1",
      "api": "openai-completions",
      "apiKey": "ollama",
      "models": [
        {
          "id": "qwen3.8-flash-next:125b-mlx",
          "name": "Qwen 3.8 Flash Next 125B — MacBook Pro",
          "reasoning": true,
          "input": ["text", "image"],
          "contextWindow": 131072,
          "maxTokens": 16384,
          "cost": {
            "input": 0,
            "output": 0,
            "cacheRead": 0,
            "cacheWrite": 0
          }
        }
      ]
    },
    "ollama-taichi": {
      "baseUrl": "http://taichi:11434/v1",
      "api": "openai-completions",
      "apiKey": "ollama",
      "models": [
        {
          "id": "qwen3.8:27b-q8_0",
          "name": "Qwen 3.8 27B Q8 — Taichi",
          "reasoning": true,
          "input": ["text", "image"],
          "contextWindow": 65536,
          "maxTokens": 16384,
          "cost": {
            "input": 0,
            "output": 0,
            "cacheRead": 0,
            "cacheWrite": 0
          }
        },
        {
          "id": "nemotron-3.5-lightning:30b-a3b",
          "name": "Nemotron 3.5 Lightning — Taichi",
          "reasoning": true,
          "input": ["text"],
          "contextWindow": 131072,
          "maxTokens": 16384,
          "cost": {
            "input": 0,
            "output": 0,
            "cacheRead": 0,
            "cacheWrite": 0
          }
        }
      ]
    }
  }
}
```

Quand un modèle est ajouté dans Ollama, il faut ajouter son entrée dans `models.json` si tu veux qu'il apparaisse explicitement dans Pi.

### OpenCode

Fichier source :

```text
~/dotfiles/home/.config/opencode/opencode.json
```

Exemple de providers :

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama-macpro": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama — MacBook Pro",
      "options": {
        "baseURL": "http://macpro:11434/v1"
      },
      "models": {
        "qwen3.8-flash-next:125b-mlx": {
          "name": "Qwen 3.8 Flash Next 125B — MacBook Pro"
        }
      }
    },
    "ollama-taichi": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama — Taichi",
      "options": {
        "baseURL": "http://taichi:11434/v1"
      },
      "models": {
        "qwen3.8:27b-q8_0": {
          "name": "Qwen 3.8 27B Q8 — Taichi"
        },
        "nemotron-3.5-lightning:30b-a3b": {
          "name": "Nemotron 3.5 Lightning — Taichi"
        }
      }
    }
  }
}
```

Quand tu ajoutes un modèle, ajoute le tag exact dans le bloc `models` correspondant pour le voir dans `/models`.

---

## 9. Open WebUI

Open WebUI est une interface web type ChatGPT qui peut se connecter directement à macpro ou Taichi.

### Docker + Colima

```bash
colima start
colima status
docker version
docker ps
```

Créer Open WebUI pour macpro :

```bash
docker run -d \
  --name open-webui \
  --restart unless-stopped \
  -p 3000:8080 \
  -e OLLAMA_BASE_URL="http://macpro:11434" \
  -v open-webui:/app/backend/data \
  ghcr.io/open-webui/open-webui:main
```

Ouvrir :

```text
http://localhost:3000
```

Commandes utiles :

```bash
docker logs -f open-webui
docker stop open-webui
docker start open-webui
docker rm -f open-webui
colima stop
```

Pour basculer Open WebUI vers Taichi :

```bash
docker rm -f open-webui

docker run -d \
  --name open-webui \
  --restart unless-stopped \
  -p 3000:8080 \
  -e OLLAMA_BASE_URL="http://taichi:11434" \
  -v open-webui:/app/backend/data \
  ghcr.io/open-webui/open-webui:main
```

Le volume `open-webui` est conservé quand seul le conteneur est supprimé. Ne pas supprimer le volume sauf pour effacer données et conversations :

```bash
docker volume rm open-webui
```

### Sans Docker, avec uv

```bash
uv tool install open-webui
OLLAMA_BASE_URL="http://macpro:11434" open-webui serve --port 3000
```

---

## 10. Diagnostics et dépannage

### Connexion directe vers les serveurs

```bash
ping -c 3 macpro
ping -c 3 taichi
tailscale status

curl http://macpro:11434/api/tags | jq
curl http://taichi:11434/api/tags | jq
```

### Vérifier les tunnels

```bash
curl http://127.0.0.1:12435/api/tags | jq
curl http://127.0.0.1:11436/api/tags | jq

ol-tunnel-macpro list
ol-tunnel-taichi list
```

### Vérifier les ports locaux sans rien modifier

```bash
lsof -nP -iTCP:11434 -sTCP:LISTEN
lsof -nP -iTCP:12435 -sTCP:LISTEN
lsof -nP -iTCP:11436 -sTCP:LISTEN
```

Interprétation :

- `11434` occupé par `Ollama` : normal, c'est l'app Ollama locale.
- `12435` occupé par `ssh` : tunnel macpro actif.
- `11436` occupé par `ssh` : tunnel Taichi actif.
- `11435` occupé par Ollama ou SSH : ne pas l'utiliser pour les tunnels ; cette config utilise déjà `12435` pour macpro.

### Erreur `tailnet policy does not permit you to SSH as user ...`

C'est une règle SSH Tailscale, pas un problème Ollama. Vérifie dans la console Tailscale que le SSH est permis entre tes machines, puis utilise les bons utilisateurs :

```bash
ssh maclino@macpro
ssh delai@taichi
```

Quitter une session interactive :

```bash
exit
```

### Erreur `bind: can't assign requested address` avec `ollama serve`

Cause : `OLLAMA_HOST` est globalement défini sur macpro, et un serveur local ne peut pas s'attacher à une IP distante. Solution : ne pas lancer `ollama serve` dans cet état. L'app Ollama GUI gère déjà le serveur local.

Si tu dois vraiment lancer un serveur local hors app GUI :

```bash
OLLAMA_HOST="http://127.0.0.1:11434" ollama serve
```

Mais seulement si le port n'est pas déjà occupé par l'app Ollama.

### Erreur `Address already in use` avec les tunnels

Ne lance pas `killall ollama` et ne lance pas `pkill ssh` globalement. Identifie d'abord le process exact :

```bash
lsof -nP -iTCP:12435 -sTCP:LISTEN
lsof -nP -iTCP:11436 -sTCP:LISTEN
```

Si tu vois déjà `ssh` sur le port concerné, le tunnel est déjà actif : il suffit de vérifier avec `ol-tunnel-macpro list` ou `ol-tunnel-taichi list`.

### macpro/Taichi travaille déjà

Ne redémarre pas Ollama distant. Créer/fermer un tunnel local ne tue pas une génération distante : le tunnel est simplement un client réseau. Ne tuer que les processus locaux nécessaires et seulement après inspection.

---

## 11. Sécurité

- Ne pas exposer le port Ollama `11434` directement sur Internet.
- Garder l'accès via Tailscale ou réseau local de confiance.
- Utiliser des ACL Tailscale pour limiter, si nécessaire, le MacBook Air à `macpro:11434` et `taichi:11434`.
- Ne jamais mettre les clés (`NVIDIA_API_KEY`, etc.) dans `home.nix`, `models.json`, `opencode.json` ou Git.
- Conserver les secrets dans `~/dotfiles/secrets/env` et protéger le dossier :

```bash
chmod 700 ~/dotfiles/secrets
chmod 600 ~/dotfiles/secrets/env
```

Vérifier que Git ignore les secrets :

```bash
cd ~/dotfiles
git check-ignore -v secrets/env
git grep -n "nvapi-" || true
```

- Tester les nouveaux modèles et agents sans `--dangerously-skip-permissions` avant de leur donner le droit de modifier des fichiers ou d'exécuter des commandes sans validation.

---

## 12. Configuration `home.nix` complète

Cette section est volontairement en dernier : elle est longue. Elle correspond au système décrit par toutes les commandes et alias de ce guide.

```nix
{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
in
{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";

  # ============================================================
  # DEVELOPMENT TOOLS
  # ============================================================

  home.packages = with pkgs; [
    # CLI
    ripgrep
    fd
    fzf
    jq
    yq
    tree
    bat
    eza
    btop
    htop
    wget
    curl
    unzip
    zip
    ollama

    # Git
    git
    git-lfs
    gh
    lazygit

    # Editor
    neovim

    # Shell
    starship
    zoxide

    # Python
    python3
    uv
    ruff
    basedpyright

    # JavaScript / TypeScript
    nodejs
    prettier

    # Go
    go
    gopls

    # Rust
    rustc
    cargo
    rustfmt
    rust-analyzer

    # Lua
    lua-language-server
    stylua

    # Shell
    bash-language-server
    shfmt

    # C / C++
    gcc
    cmake
    gnumake
    pkg-config

    # Containers
    docker
    docker-compose
    colima

    # AI agents
    pi-coding-agent
    opencode

    # Fonts
    nerd-fonts.hack
  ];

  # ============================================================
  # ENVIRONMENT
  # ============================================================

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";

    # Default Ollama server for the shell and existing applications.
    # Direct Tailscale connection to macpro.
    OLLAMA_HOST = "http://macpro:11434";
  };

  # ============================================================
  # ZSH
  # ============================================================

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      bindkey '^f' autosuggest-accept

      # Default Ollama server: MacBook Pro 128 GB via Tailscale.
      export OLLAMA_HOST="http://macpro:11434"

      # API keys are local, outside the Nix store and ignored by Git.
      # Expected file: ~/dotfiles/secrets/env
      if [ -f "$HOME/dotfiles/secrets/env" ]; then
        source "$HOME/dotfiles/secrets/env"
      fi
    '';

    shellAliases = {
      # Navigation
      ".." = "cd ..";

      # Git
      add = "git add .";
      push = "git push";
      pull = "git pull";
      gs = "git status";
      lg = "lazygit";
      m = "git switch main";

      # Neovim
      v = "nvim";
      vi = "nvim";

      # Files
      ll = "eza -la";
      cat = "bat";

      # Existing coding agents
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";

      # ============================================================
      # DIRECT OLLAMA SERVERS VIA TAILSCALE
      # These aliases select a SERVER, not a fixed model.
      # ============================================================

      # Default Ollama server: macpro, inherited from OLLAMA_HOST.
      ol = "ollama";
      ol-list = "ollama list";

      # macpro: Apple Silicon / 128 GB (DIRECT)
      ol-macpro = ''OLLAMA_HOST="http://macpro:11434" ollama'';
      cc-macpro = ''OLLAMA_HOST="http://macpro:11434" ollama launch claude'';
      co-macpro = ''OLLAMA_HOST="http://macpro:11434" ollama launch opencode'';

      # Taichi: Ubuntu / 2x RTX 3090 (DIRECT)
      ol-taichi = ''OLLAMA_HOST="http://taichi:11434" ollama'';
      cc-taichi = ''OLLAMA_HOST="http://taichi:11434" ollama launch claude'';
      co-taichi = ''OLLAMA_HOST="http://taichi:11434" ollama launch opencode'';

      # Local Ollama app/models, if installed on this Mac.
      ol-local = ''OLLAMA_HOST="http://127.0.0.1:11434" ollama'';

      # ============================================================
      # CLAUDE DESKTOP VIA OLLAMA + SSH TUNNELS
      #
      # 127.0.0.1:11434 -> Ollama app installed on this Mac
      # 127.0.0.1:12435 -> macpro:11434 (SSH user: maclino)
      # 127.0.0.1:11436 -> taichi:11434 (SSH user: delai)
      #
      # This section does not change global OLLAMA_HOST or the app.
      # ============================================================

      # Open SSH tunnels in the background.
      ol-tunnels = ''
        ssh -fN -L 127.0.0.1:12435:localhost:11434 maclino@macpro
        ssh -fN -L 127.0.0.1:11436:localhost:11434 delai@taichi
      '';

      # Stop only the SSH processes created for these two tunnels.
      ol-stop-tunnels = ''
        pkill -f "ssh -fN -L 127.0.0.1:12435:localhost:11434 maclino@macpro" || true
        pkill -f "ssh -fN -L 127.0.0.1:11436:localhost:11434 delai@taichi" || true
      '';

      # Inspect local and tunneled model lists.
      ol-tunnel-macpro = ''OLLAMA_HOST="http://127.0.0.1:12435" ollama'';
      ol-tunnel-taichi = ''OLLAMA_HOST="http://127.0.0.1:11436" ollama'';

      # Claude Desktop -> local Ollama app and locally downloaded models.
      claude-local = ''
        launchctl setenv OLLAMA_HOST "http://127.0.0.1:11434"
        killall Claude 2>/dev/null || true
        open -a Claude
      '';

      # Claude Desktop -> macpro models through SSH tunnel on port 12435.
      claude-macpro = ''
        launchctl setenv OLLAMA_HOST "http://127.0.0.1:12435"
        killall Claude 2>/dev/null || true
        open -a Claude
      '';

      # Claude Desktop -> Taichi models through SSH tunnel on port 11436.
      claude-taichi = ''
        launchctl setenv OLLAMA_HOST "http://127.0.0.1:11436"
        killall Claude 2>/dev/null || true
        open -a Claude
      '';

      # ============================================================
      # NVIDIA BUILD / NIM VIA PI
      # Model choice is done interactively inside Pi: /model or Ctrl+L.
      # ============================================================

      pi-nvidia = ''pi --api-key "$NVIDIA_API_KEY"'';

      pinvidia =
        ''pi --model nvidia/nemotron-3-super-120b-a12b --api-key "$NVIDIA_API_KEY"'';

      pinvidia-ultra =
        ''pi --model nvidia/nemotron-3-ultra-550b-a55b --api-key "$NVIDIA_API_KEY"'';

      pideepseek =
        ''pi --model deepseek-ai/deepseek-v4-pro-0813 --api-key "$NVIDIA_API_KEY"'';
    };
  };

  # ============================================================
  # STARSHIP
  # ============================================================

  programs.starship = {
    enable = true;

    settings = {
      add_newline = false;

      format =
        "$directory$git_branch$git_status$cmd_duration$line_break$character";

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };

      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # ============================================================
  # ZOXIDE
  # ============================================================

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # ============================================================
  # DOTFILES
  # ============================================================

  home.file.".config/wezterm" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/.config/wezterm";
    force = true;
  };

  home.file.".config/nvim" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/.config/nvim";
    force = true;
  };

  home.file.".config/herdr" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/.config/herdr";
    force = true;
  };

  home.file.".claude/settings.json" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/.claude/settings.json";
    force = true;
  };

  # ============================================================
  # PI CODING AGENT
  # ============================================================

  home.file.".pi/agent/settings.json" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/.pi/agent/settings.json";
    force = true;
  };

  home.file.".pi/agent/models.json" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/.pi/agent/models.json";
    force = true;
  };

  # ============================================================
  # SHARED AGENTS
  # ============================================================

  home.file.".claude/CLAUDE.md" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/AGENTS.md";
    force = true;
  };

  home.file.".codex/AGENTS.md" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/AGENTS.md";
    force = true;
  };

  home.file.".config/opencode/AGENTS.md" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/AGENTS.md";
    force = true;
  };

  home.file.".config/opencode/opencode.json" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
        "${dotfiles}/home/.config/opencode/opencode.json";
    force = true;
  };
}
```

Après une modification du fichier :

```bash
cd ~/dotfiles
./rebuild.sh
exec zsh
```

Vérifier ensuite :

```bash
echo "$OLLAMA_HOST"
ol-macpro list
ol-taichi list
```

Résultat attendu pour `OLLAMA_HOST` :

```text
http://macpro:11434
```

---

## Résumé final

- **Terminal et application existante** : continuent d'utiliser macpro directement via `OLLAMA_HOST=http://macpro:11434`.
- **Claude Code/OpenCode sur macpro ou Taichi** : utiliser `cc-macpro`, `cc-taichi`, `co-macpro`, `co-taichi`; aucun tunnel requis.
- **Claude Desktop avec macpro ou Taichi** : `ol-tunnels`, puis `claude-macpro` ou `claude-taichi`.
- **Claude Desktop local** : `claude-local`.
- **Tunnels** : uniquement des routes réseau locales, sans effet sur les modèles ni travaux actifs sur macpro/Taichi.
- **Nix** : configure paquets, variables, alias et liens de fichiers; il ne stocke ni ne télécharge les modèles distants.
