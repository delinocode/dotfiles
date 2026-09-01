#!/usr/bin/env python3
"""
Synchronise les serveurs LLM locaux/distants avec Zed.

Ce script :
- Ajoute automatiquement les modèles découverts.
- Demande confirmation avant toute suppression.
- Ne supprime jamais de modèle si son serveur est inaccessible.
- Crée une sauvegarde de settings.json avant écriture.
- Utilise des provider IDs simples et fiables pour Zed.
- Crée ~/.config/zed/local-llm.env avec les clés factices nécessaires.

Après exécution, démarre Zed avec :
    zed-local

Ou manuellement :
    source ~/.config/zed/local-llm.env
    open -a Zed
"""

from __future__ import annotations

import copy
import datetime as dt
import json
import re
import shutil
import sys
import urllib.error
import urllib.request
from pathlib import Path


ZED_DIR = Path.home() / ".config" / "zed"
ZED_SETTINGS = ZED_DIR / "settings.json"
ZED_ENV = ZED_DIR / "local-llm.env"

TIMEOUT_SECONDS = 5
DEFAULT_CONTEXT = 131072
DEFAULT_MAX_OUTPUT = 16384
MIN_VALID_CONTEXT = 4096

# provider_id est l'identifiant technique Zed.
# La variable de clé est automatiquement :
#   PROVIDER_ID_EN_MAJUSCULE + "_API_KEY"
#
# Exemple :
#   omlx_air => OMLX_AIR_API_KEY=local
SERVERS = [
    {
        "provider_id": "mlx_serve_air",
        "display_name": "MLX Serve Air",
        "kind": "mlx",
        "base_url": "http://localhost:11138",
    },
    {
        "provider_id": "omlx_air",
        "display_name": "oMLX Air",
        "kind": "omlx",
        "base_url": "http://localhost:8038",
    },
    {
        "provider_id": "mlx_serve_macpro",
        "display_name": "MLX Serve Mac Pro",
        "kind": "mlx",
        "base_url": "http://macpro:11234",
    },
    {
        "provider_id": "ollama_macpro",
        "display_name": "Ollama Mac Pro",
        "kind": "ollama",
        "base_url": "http://macpro:11434",
    },
    {
        "provider_id": "ollama_taichi",
        "display_name": "Ollama Taichi",
        "kind": "ollama",
        "base_url": "http://taichi:11434",
    },
]


def get_json(url: str) -> dict:
    request = urllib.request.Request(
        url,
        headers={
            "Accept": "application/json",
            "User-Agent": "zed-models/4.0",
        },
    )
    with urllib.request.urlopen(request, timeout=TIMEOUT_SECONDS) as response:
        return json.loads(response.read().decode("utf-8"))


def valid_context(value: object) -> int | None:
    try:
        context = int(value)
    except (TypeError, ValueError):
        return None

    if context < MIN_VALID_CONTEXT:
        return None

    return context


def best_context(values: list[object]) -> int | None:
    candidates = []

    for value in values:
        context = valid_context(value)
        if context is not None:
            candidates.append(context)

    return max(candidates) if candidates else None


def context_label(context: int) -> str:
    return f"{context // 1024}K"


def zed_capabilities(tools: bool, images: bool) -> dict:
    return {
        "tools": tools,
        "images": images,
        "parallel_tool_calls": False,
        "prompt_cache_key": False,
        "chat_completions": True,
        "interleaved_reasoning": False,
        "max_tokens_parameter": False,
    }


def make_model(
    *,
    model_id: str,
    provider_display_name: str,
    context: int,
    tools: bool = True,
    images: bool = False,
    unloaded: bool = False,
) -> dict:
    label = (
        f"{model_id} — {provider_display_name} "
        f"({context_label(context)})"
    )

    if unloaded:
        label += " — unloaded"

    return {
        "name": model_id,
        "display_name": label,
        "max_tokens": context,
        "max_output_tokens": DEFAULT_MAX_OUTPUT,
        "capabilities": zed_capabilities(tools=tools, images=images),
    }


def fetch_mlx_models(server: dict) -> list[dict]:
    payload = get_json(f"{server['base_url']}/v1/models")
    result = []

    for item in payload.get("data", []):
        model_id = item.get("id")
        if not model_id:
            continue

        meta = item.get("meta") or {}
        context = best_context(
            [
                item.get("context_length"),
                item.get("max_model_len"),
                meta.get("context_length"),
                meta.get("model_max_tokens"),
                meta.get("max_model_len"),
            ]
        ) or DEFAULT_CONTEXT

        capabilities = item.get("capabilities") or []
        modalities = item.get("input_modalities") or []

        supports_tools = "tool_use" in capabilities
        supports_images = "vision" in capabilities or "image" in modalities

        state = str(item.get("state", "")).lower()
        loaded = bool(item.get("loaded", False))
        unloaded = state == "unloaded" and not loaded

        result.append(
            make_model(
                model_id=model_id,
                provider_display_name=server["display_name"],
                context=context,
                tools=supports_tools,
                images=supports_images,
                unloaded=unloaded,
            )
        )

    return result


def fetch_omlx_models(server: dict) -> list[dict]:
    """
    oMLX retourne actuellement un format plus simple :
    id, owned_by, max_model_len.

    max_model_len est la valeur importante pour Zed.
    """
    payload = get_json(f"{server['base_url']}/v1/models")
    result = []

    for item in payload.get("data", []):
        model_id = item.get("id")
        if not model_id:
            continue

        meta = item.get("meta") or {}
        context = best_context(
            [
                item.get("max_model_len"),
                item.get("context_length"),
                meta.get("max_model_len"),
                meta.get("context_length"),
                meta.get("model_max_tokens"),
            ]
        ) or DEFAULT_CONTEXT

        result.append(
            make_model(
                model_id=model_id,
                provider_display_name=server["display_name"],
                context=context,
                tools=True,
                images=False,
                unloaded=False,
            )
        )

    return result


def fetch_ollama_models(server: dict) -> list[dict]:
    """
    /api/tags d'Ollama ne donne pas toujours la vraie fenêtre de contexte.
    On affecte une valeur par défaut pour les nouveaux modèles et, plus bas,
    on conserve la valeur déjà présente dans Zed pour les modèles existants.
    """
    payload = get_json(f"{server['base_url']}/api/tags")
    result = []

    for item in payload.get("models", []):
        model_id = item.get("name")
        if not model_id:
            continue

        result.append(
            make_model(
                model_id=model_id,
                provider_display_name=server["display_name"],
                context=DEFAULT_CONTEXT,
                tools=True,
                images=False,
                unloaded=False,
            )
        )

    return result


def fetch_models(server: dict) -> list[dict]:
    if server["kind"] == "mlx":
        return fetch_mlx_models(server)

    if server["kind"] == "omlx":
        return fetch_omlx_models(server)

    if server["kind"] == "ollama":
        return fetch_ollama_models(server)

    raise ValueError(f"Type de serveur inconnu : {server['kind']}")


def strip_jsonc_comments(text: str) -> str:
    output = []
    i = 0
    in_string = False
    escaped = False

    while i < len(text):
        char = text[i]
        next_char = text[i + 1] if i + 1 < len(text) else ""

        if in_string:
            output.append(char)

            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False

            i += 1
            continue

        if char == '"':
            in_string = True
            output.append(char)
            i += 1
            continue

        if char == "/" and next_char == "/":
            i += 2
            while i < len(text) and text[i] not in "\r\n":
                i += 1
            continue

        if char == "/" and next_char == "*":
            i += 2
            while i + 1 < len(text):
                if text[i] == "*" and text[i + 1] == "/":
                    i += 2
                    break
                i += 1
            continue

        output.append(char)
        i += 1

    return "".join(output)


def remove_trailing_commas(text: str) -> str:
    return re.sub(r",(\s*[}\]])", r"\1", text)


def load_settings() -> dict:
    if not ZED_SETTINGS.exists():
        print(f"Erreur : fichier Zed introuvable : {ZED_SETTINGS}")
        sys.exit(1)

    raw = ZED_SETTINGS.read_text(encoding="utf-8")
    cleaned = remove_trailing_commas(strip_jsonc_comments(raw))

    try:
        return json.loads(cleaned)
    except json.JSONDecodeError as error:
        print(f"Erreur JSON dans {ZED_SETTINGS}, ligne {error.lineno}.")
        print(error.msg)
        print("Aucun fichier n'a été modifié.")
        sys.exit(1)


def models_by_id(models: list[dict]) -> dict[str, dict]:
    return {
        model["name"]: model
        for model in models
        if isinstance(model, dict) and model.get("name")
    }


def yes_or_no(question: str) -> bool:
    while True:
        answer = input(f"{question} [y/N] : ").strip().lower()

        if answer in ("", "n", "no", "non"):
            return False

        if answer in ("y", "yes", "o", "oui"):
            return True

        print("Réponds y/yes/oui ou n/no/non.")


def make_backup() -> Path:
    timestamp = dt.datetime.now().strftime("%Y%m%d-%H%M%S")
    backup = ZED_SETTINGS.with_name(f"settings.json.backup-{timestamp}")
    shutil.copy2(ZED_SETTINGS, backup)
    return backup


def provider_env_name(provider_id: str) -> str:
    normalized = re.sub(r"[^A-Za-z0-9]+", "_", provider_id).upper()
    return f"{normalized}_API_KEY"


def write_zed_env() -> Path:
    """
    Crée les clés factices pour les endpoints locaux.
    Elles ne sont pas des secrets : oMLX, mlx-serve et Ollama locaux
    n'ont pas d'authentification activée ici.

    Zed exige toutefois une valeur non vide pour initialiser certains
    providers OpenAI-compatibles.
    """
    ZED_DIR.mkdir(parents=True, exist_ok=True)

    lines = [
        "# Généré par ~/dotfiles/scripts/zed-models",
        "# Valeurs locales factices pour les providers OpenAI-compatibles Zed.",
        "# Ne pas mettre de vraie clé API ici.",
    ]

    for server in SERVERS:
        lines.append(f"export {provider_env_name(server['provider_id'])}=local")

    ZED_ENV.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return ZED_ENV


def clean_old_provider_names(providers: dict) -> bool:
    """
    Renomme automatiquement les anciens noms humains créés par les versions
    précédentes du script vers les IDs techniques que Zed reconnaît mieux.
    """
    legacy_names = {
        "MLX Serve Air": "mlx_serve_air",
        "oMLX Air": "omlx_air",
        "MLX Serve Mac Pro": "mlx_serve_macpro",
        "Ollama Mac Pro": "ollama_macpro",
        "Ollama Taichi": "ollama_taichi",
    }

    changed = False

    for old_name, new_name in legacy_names.items():
        if old_name in providers and new_name not in providers:
            providers[new_name] = providers.pop(old_name)
            changed = True
            print(f"  ~ Provider renommé : {old_name} → {new_name}")

    return changed


def merge_model(
    *,
    server: dict,
    existing: dict,
    detected: dict,
) -> dict:
    """
    Fusionne une entrée existante avec une entrée détectée.

    Pour MLX/oMLX : la valeur API fiable devient la référence.
    Pour Ollama : conserve le contexte existant, car /api/tags ne le donne pas.
    """
    merged = {**existing, **detected}

    old_context = valid_context(existing.get("max_tokens"))
    detected_context = valid_context(detected.get("max_tokens"))

    if server["kind"] == "ollama":
        final_context = old_context or detected_context or DEFAULT_CONTEXT
    else:
        final_context = detected_context or old_context or DEFAULT_CONTEXT

    merged["max_tokens"] = final_context
    merged["max_output_tokens"] = (
        valid_context(detected.get("max_output_tokens"))
        or valid_context(existing.get("max_output_tokens"))
        or DEFAULT_MAX_OUTPUT
    )

    detected_label = str(detected.get("display_name", "")).lower()
    unloaded = "unloaded" in detected_label

    merged["display_name"] = make_model(
        model_id=merged["name"],
        provider_display_name=server["display_name"],
        context=final_context,
        tools=bool(merged.get("capabilities", {}).get("tools", True)),
        images=bool(merged.get("capabilities", {}).get("images", False)),
        unloaded=unloaded,
    )["display_name"]

    return merged


def main() -> None:
    settings = load_settings()
    new_settings = copy.deepcopy(settings)

    language_models = new_settings.setdefault("language_models", {})
    providers = language_models.setdefault("openai_compatible", {})

    changed = clean_old_provider_names(providers)

    # Produit les variables de clé nécessaires à Zed.
    env_file = write_zed_env()

    discovered: dict[str, list[dict]] = {}
    reachable: set[str] = set()

    print("Recherche des modèles…\n")

    for server in SERVERS:
        provider_id = server["provider_id"]

        try:
            models = fetch_models(server)
            discovered[provider_id] = models
            reachable.add(provider_id)
            print(
                f"✓ {server['display_name']}: "
                f"{len(models)} modèle(s) détecté(s)"
            )
        except (
            urllib.error.URLError,
            urllib.error.HTTPError,
            TimeoutError,
            json.JSONDecodeError,
            ValueError,
        ) as error:
            print(
                f"✗ {server['display_name']}: inaccessible — "
                "aucune suppression ne sera proposée"
            )
            print(f"  {error}")

    for server in SERVERS:
        provider_id = server["provider_id"]

        # Ne rien modifier si le serveur ne répond pas.
        if provider_id not in reachable:
            continue

        api_url = f"{server['base_url']}/v1"
        detected_models = discovered[provider_id]
        detected_by_id = models_by_id(detected_models)

        provider = providers.setdefault(
            provider_id,
            {
                "api_url": api_url,
                "available_models": [],
            },
        )

        if provider.get("api_url") != api_url:
            provider["api_url"] = api_url
            changed = True
            print(f"  ~ URL mise à jour : {server['display_name']}")

        current_models = provider.setdefault("available_models", [])
        current_by_id = models_by_id(current_models)

        # Nouveaux modèles : ajout automatique.
        for model_id, detected_model in detected_by_id.items():
            if model_id not in current_by_id:
                current_models.append(detected_model)
                changed = True
                print(f"  + Ajouté : {server['display_name']} / {model_id}")

        # Modèles connus : mise à jour des métadonnées.
        refreshed_models = []

        for existing_model in current_models:
            model_id = existing_model.get("name")
            detected_model = detected_by_id.get(model_id)

            if detected_model is None:
                refreshed_models.append(existing_model)
                continue

            merged = merge_model(
                server=server,
                existing=existing_model,
                detected=detected_model,
            )

            refreshed_models.append(merged)

            if merged != existing_model:
                changed = True
                print(f"  ~ Mis à jour : {server['display_name']} / {model_id}")

        provider["available_models"] = refreshed_models
        current_models = refreshed_models

        # Modèles absents : confirmation obligatoire.
        detected_ids = set(detected_by_id)
        missing_models = [
            model
            for model in list(current_models)
            if model.get("name") and model["name"] not in detected_ids
        ]

        for missing_model in missing_models:
            model_id = missing_model["name"]

            print("\nModèle absent du serveur :")
            print(f"  Provider : {server['display_name']}")
            print(f"  Modèle   : {model_id}")

            if yes_or_no("Le supprimer de Zed ?"):
                current_models.remove(missing_model)
                changed = True
                print(f"  - Supprimé : {server['display_name']} / {model_id}")
            else:
                print(f"  = Conservé : {server['display_name']} / {model_id}")

    # Si le modèle par défaut faisait référence à l'ancien nom oMLX,
    # il est migré automatiquement vers le nouvel ID stable.
    agent = new_settings.get("agent")
    if isinstance(agent, dict):
        default_model = agent.get("default_model")
        if isinstance(default_model, dict):
            legacy_default_providers = {
                "MLX Serve Air": "mlx_serve_air",
                "oMLX Air": "omlx_air",
                "MLX Serve Mac Pro": "mlx_serve_macpro",
                "Ollama Mac Pro": "ollama_macpro",
                "Ollama Taichi": "ollama_taichi",
            }

            old_provider = default_model.get("provider")
            new_provider = legacy_default_providers.get(old_provider)

            if new_provider:
                default_model["provider"] = new_provider
                changed = True
                print(
                    f"\n  ~ Modèle par défaut : "
                    f"{old_provider} → {new_provider}"
                )

    if not changed:
        print("\nAucun changement dans settings.json.")
        print(f"Fichier de clés Zed vérifié : {env_file}")
        return

    backup = make_backup()
    rendered = json.dumps(new_settings, indent=2, ensure_ascii=False) + "\n"
    ZED_SETTINGS.write_text(rendered, encoding="utf-8")

    print("\nSynchronisation terminée.")
    print(f"Sauvegarde : {backup}")
    print(f"Settings Zed : {ZED_SETTINGS}")
    print(f"Clés locales Zed : {env_file}")
    print()
    print("Pour démarrer Zed avec les providers locaux :")
    print("  source ~/.config/zed/local-llm.env && open -a Zed")


if __name__ == "__main__":
    main()
