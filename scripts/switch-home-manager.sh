#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NIX_BIN="${NIX_BIN:-/nix/var/nix/profiles/default/bin/nix}"

if command -v home-manager >/dev/null 2>&1; then
  exec home-manager switch --flake "${REPO_DIR}#gustvmar"
fi

exec "${NIX_BIN}" run github:nix-community/home-manager/release-24.11 -- switch --flake "${REPO_DIR}#gustvmar"
