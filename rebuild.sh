#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

cd "$DIR"

exec sudo darwin-rebuild switch --flake "$DIR#mac"