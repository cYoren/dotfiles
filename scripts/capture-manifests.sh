#!/usr/bin/env bash
# Refresh package names for this Arch install; review before committing.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
command -v pacman >/dev/null || { echo "pacman is required" >&2; exit 1; }

pacman -Qnqe | sort -u > "$REPO/manifests/pacman-explicit.txt"
pacman -Qme | awk '{print $1}' | sort -u > "$REPO/manifests/aur.txt"
echo "Updated native and foreign explicit package lists. Review with git diff."
