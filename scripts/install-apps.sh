#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APT_MANUAL="${REPO_DIR}/manifests/apt-manual.txt"
FLATPAK_APPS="${REPO_DIR}/manifests/flatpak-apps.txt"
NIX_PROFILE="${REPO_DIR}/manifests/nix-profile.txt"
NIX_PROFILE_INSTALL="${REPO_DIR}/manifests/nix-profile-install.txt"
NIX_BIN="${NIX_BIN:-/nix/var/nix/profiles/default/bin/nix}"

echo "Using manifests from ${REPO_DIR}/manifests"

if command -v apt >/dev/null 2>&1; then
  echo
  echo "Installing APT manual packages"
  sudo apt update
  sudo xargs -a "${APT_MANUAL}" apt install -y
else
  echo "Skipping APT install: apt not found"
fi

if command -v flatpak >/dev/null 2>&1; then
  echo
  echo "Installing Flatpak apps"
  while read -r app origin; do
    [[ -z "${app}" ]] && continue
    flatpak install -y "${origin}" "${app}"
  done < "${FLATPAK_APPS}"
else
  echo "Skipping Flatpak install: flatpak not found"
fi

if [[ -x "${NIX_BIN}" ]]; then
  echo
  echo "Installing Nix profile packages"
  while read -r ref; do
    [[ -z "${ref}" ]] && continue
    "${NIX_BIN}" profile install "${ref}" || true
  done < "${NIX_PROFILE_INSTALL}"
else
  echo "Skipping Nix profile install: nix binary not found at ${NIX_BIN}"
fi

echo
echo "App installation pass complete."
echo "Some packages may need manual adjustment depending on distro release and available channels."
