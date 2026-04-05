#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_HOME="${HOME}"

echo "Restoring dotfiles from: ${REPO_DIR}"
echo "Target home: ${TARGET_HOME}"

rsync -av \
  --exclude '.git/' \
  --exclude '.gitignore' \
  --exclude 'README.md' \
  --exclude 'manifests/' \
  --exclude 'scripts/' \
  "${REPO_DIR}/" "${TARGET_HOME}/"

echo
echo "Restore complete."
echo "Review overwritten files before logging out."
