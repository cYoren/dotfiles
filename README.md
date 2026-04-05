# Gustavo's Private Dotfiles

Private backup and restore kit for this machine's desktop setup.

## What is backed up

- Hyprland config and helper scripts
- Plasma / KDE desktop state and key shortcuts
- Waybar, Wofi, Rofi, Kitty, Alacritty, GTK, Qt, and Starship config
- Nix Home Manager entrypoints
- Generated wallpaper assets and wallpaper tooling
- App manifests for APT, Flatpak, and Nix profile packages

This repo is intentionally focused on ricing, desktop behavior, and reproducible app setup. It is not a full-home backup.

## Layout

- `.config/`: desktop and app config
- `.local/bin/`: local helper scripts
- `Pictures/wallpapers/`: wallpaper assets used by the setup
- `manifests/`: package inventories for reinstalling apps
- `scripts/`: restore helpers
- `home.nix`, `flake.nix`: Nix entrypoints from the machine

## Restore on a new machine

1. Clone the repo somewhere under your home directory.
2. Review `manifests/apt-manual.txt`, `manifests/flatpak-apps.txt`, and `manifests/nix-profile.txt`.
3. Run `scripts/install-apps.sh` to reinstall the package layers you want.
4. Run `scripts/restore-dotfiles.sh` to copy the tracked config back into `$HOME`.
5. Re-run your normal Home Manager or Nix flow if you want the Nix side fully re-applied.
6. Log out and back in so Plasma / Hyprland pick up everything cleanly.

## Notes

- The restore script uses `rsync` and excludes repo metadata.
- The app installer uses `sudo apt`, `flatpak`, and `nix profile install` when available.
- Some packages may not exist on a future distro release. Treat the manifests as the source of truth, not as a guarantee that every package name will stay valid forever.
