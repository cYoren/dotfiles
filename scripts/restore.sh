#!/usr/bin/env bash
# Restore the checked-in user configs without deleting unrelated home files.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN=0

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=1
  shift
fi
if (($#)); then
  echo "Usage: $0 [--dry-run]" >&2
  exit 2
fi

if ((DRY_RUN)); then
  rsync -av --dry-run --itemize-changes "$REPO/.config/" "$HOME/.config/"
  rsync -av --dry-run --itemize-changes "$REPO/.local/" "$HOME/.local/"
  rsync -av --dry-run --itemize-changes \
    "$REPO/.bashrc" "$REPO/.bash_profile" "$REPO/.profile" "$REPO/.zshrc" "$HOME/"
else
  stamp="$(date +%Y%m%d-%H%M%S)"
  BACKUP_DIR="$HOME/.local/state/dotfiles-restore-backups/$stamp"
  mkdir -p "$BACKUP_DIR/.config" "$BACKUP_DIR/.local"
  mkdir -p "$BACKUP_DIR/root"
  rsync -av --backup --backup-dir="$BACKUP_DIR/.config" "$REPO/.config/" "$HOME/.config/"
  rsync -av --backup --backup-dir="$BACKUP_DIR/.local" "$REPO/.local/" "$HOME/.local/"
  rsync -av --backup --backup-dir="$BACKUP_DIR/root" \
    "$REPO/.bashrc" "$REPO/.bash_profile" "$REPO/.profile" "$REPO/.zshrc" "$HOME/"
  echo "Previous versions of replaced files, if any, are in: $BACKUP_DIR"

  systemctl --user daemon-reload
  systemctl --user enable asciify-fluid-wallpaper.service
  if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
    systemctl --user restart asciify-fluid-wallpaper.service
  else
    echo "Wallpaper service enabled; it will start with the next graphical session."
  fi
  echo "Kernel options are documented in README.md; /etc changes are not applied automatically."
fi
