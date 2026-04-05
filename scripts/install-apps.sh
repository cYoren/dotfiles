#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST_DIR="${REPO_DIR}/manifests"
NIX_BIN="${NIX_BIN:-/nix/var/nix/profiles/default/bin/nix}"

DEFAULT_GROUPS=(desktop dev gaming science system plasma creative cosmic hypr)
SELECTED_GROUPS=("$@")

if [[ ${#SELECTED_GROUPS[@]} -eq 0 ]]; then
  SELECTED_GROUPS=("${DEFAULT_GROUPS[@]}")
fi

install_apt_group() {
  local group="$1"
  local file="${MANIFEST_DIR}/apt-${group}.txt"
  [[ -f "${file}" ]] || return 0
  command -v apt >/dev/null 2>&1 || return 0

  echo
  echo "Installing APT group: ${group}"
  sudo apt update
  sudo xargs -a "${file}" apt install -y
}

install_flatpak_group() {
  local group="$1"
  local file="${MANIFEST_DIR}/flatpak-${group}.txt"
  [[ -f "${file}" ]] || return 0
  command -v flatpak >/dev/null 2>&1 || return 0

  echo
  echo "Installing Flatpak group: ${group}"
  while read -r app origin; do
    [[ -z "${app:-}" ]] && continue
    flatpak install -y "${origin}" "${app}"
  done < "${file}"
}

install_nix_group() {
  local group="$1"
  local file="${MANIFEST_DIR}/nix-${group}.txt"
  [[ -f "${file}" ]] || return 0
  [[ -x "${NIX_BIN}" ]] || return 0

  echo
  echo "Installing Nix group: ${group}"
  while read -r ref; do
    [[ -z "${ref:-}" ]] && continue
    "${NIX_BIN}" profile install "${ref}" || true
  done < "${file}"
}

echo "Using manifests from ${MANIFEST_DIR}"
echo "Selected groups: ${SELECTED_GROUPS[*]}"

for group in "${SELECTED_GROUPS[@]}"; do
  install_apt_group "${group}"
done

for group in "${SELECTED_GROUPS[@]}"; do
  install_flatpak_group "${group}"
done

for group in "${SELECTED_GROUPS[@]}"; do
  install_nix_group "${group}"
done

echo
echo "Installation pass complete."
echo "Available groups: ${DEFAULT_GROUPS[*]}"
