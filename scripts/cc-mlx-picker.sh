#!/usr/bin/env bash
set -euo pipefail

endpoint="${MLX_ENDPOINT:-http://macpro:11234}"

if ! command -v jq >/dev/null 2>&1; then
  printf 'Error: jq is required.\n' >&2
  exit 1
fi

models_json="$(curl --fail --silent --show-error "${endpoint}/v1/models")" || {
  printf 'Error: unable to reach MLX Serve at %s/v1/models\n' "$endpoint" >&2
  exit 1
}

mapfile -t models < <(
  printf '%s\n' "$models_json" |
    jq -r '.data[] | select((.state // "") != "error") | .id' |
    sort -f
)

if ((${#models[@]} == 0)); then
  printf 'No usable models returned by %s/v1/models\n' "$endpoint" >&2
  exit 1
fi

printf '\nMLX Serve: %s\n\n' "$endpoint"
for i in "${!models[@]}"; do
  printf '  %d) %s\n' "$((i + 1))" "${models[$i]}"
done
printf '\nChoose a model [1-%d] (q to quit): ' "${#models[@]}"
read -r choice

case "$choice" in
  q|Q|"") exit 0 ;;
esac

if ! [[ "$choice" =~ ^[0-9]+$ ]] || ((choice < 1 || choice > ${#models[@]})); then
  printf 'Invalid selection.\n' >&2
  exit 1
fi

model="${models[$((choice - 1))]}"
printf '\nStarting Claude Code with: %s\n\n' "$model"

exec env \
  ANTHROPIC_AUTH_TOKEN="ollama" \
  ANTHROPIC_API_KEY="" \
  ANTHROPIC_BASE_URL="$endpoint" \
  claude --model "$model"
