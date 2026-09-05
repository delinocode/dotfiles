#!/usr/bin/env bash
set -u

echo "==> Host"
hostnamectl 2>/dev/null || hostname
uname -m
[ -r /etc/os-release ] && sed -n '1,8p' /etc/os-release

echo
echo "==> Commands"
for cmd in nix home-manager ollama tmux zsh nvim opencode pi claude; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '%-15s %s\n' "$cmd:" "$(command -v "$cmd")"
  else
    printf '%-15s %s\n' "$cmd:" "NOT FOUND"
  fi
done

echo
echo "==> Local Taichi Ollama models"
curl -fsS http://taichi:11434/api/tags 2>/dev/null | jq -r '.models[].name' || echo "Taichi Ollama unavailable"

echo
echo "==> Local Taichi loaded models"
curl -fsS http://taichi:11434/api/ps 2>/dev/null | jq || echo "Unable to query Taichi /api/ps"

echo
echo "==> Mac Pro Ollama models"
curl -fsS http://macpro:11434/api/tags 2>/dev/null | jq -r '.models[].name' || echo "Mac Pro Ollama unavailable"

echo
echo "==> Mac Pro MLX Serve models"
curl -fsS http://macpro:11234/v1/models 2>/dev/null | jq -r '.data[].id' || echo "Mac Pro MLX Serve unavailable"

echo
echo "==> GPU"
if command -v nvidia-smi >/dev/null 2>&1; then
  nvidia-smi --query-gpu=name,memory.total,memory.used,utilization.gpu --format=csv,noheader
else
  echo "nvidia-smi not found"
fi

echo
echo "==> Tailscale"
if command -v tailscale >/dev/null 2>&1; then tailscale status; else echo "tailscale command not found"; fi

echo
echo "==> tmux sessions"
tmux ls 2>/dev/null || echo "No tmux sessions."
