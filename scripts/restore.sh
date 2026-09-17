#!/usr/bin/env bash
# Copy the Omarchy dotfiles into $HOME and enable the ASCII wallpaper.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

rsync -av "$REPO/.config/" "$HOME/.config/"
rsync -av "$REPO/.local/" "$HOME/.local/"

echo "Kernel module options (needs sudo): cp $REPO/etc/modprobe.d/nvidia.conf /etc/modprobe.d/"
systemctl --user daemon-reload
systemctl --user enable --now asciify-fluid-wallpaper.service
echo "Done. Reload Hyprland (SUPER+ESC > Reload) or log out/in."
