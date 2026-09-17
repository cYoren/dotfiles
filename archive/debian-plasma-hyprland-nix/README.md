# Gustavo's Private Dotfiles

Private backup and restore kit for this machine's desktop setup, with the Hyprland layer promoted to a real Home Manager source of truth.

## What is backed up

- Hyprland config and helper scripts
- Plasma / KDE desktop state and key shortcuts
- Waybar, Wofi, Rofi, Kitty, Alacritty, GTK, Qt, and Starship config
- Nix Home Manager entrypoints
- Generated wallpaper assets and wallpaper tooling
- Split app manifests for APT, Flatpak, and Nix profile packages

This repo is intentionally focused on ricing, desktop behavior, and reproducible app setup. It is not a full-home backup.

## Layout

- `.config/`: desktop and app config
- `.local/bin/`: local helper scripts
- `Pictures/wallpapers/`: wallpaper assets used by the setup
- `manifests/`: package inventories for reinstalling apps
- `scripts/`: restore helpers and Home Manager switch helpers
- `home.nix`, `flake.nix`: Nix entrypoints from the machine

## Restore on a new machine

1. Clone the repo somewhere under your home directory.
2. Review the split manifests under `manifests/`.
3. Run `scripts/install-apps.sh` with the groups you want.
4. Run `scripts/restore-dotfiles.sh` if you want to copy the full snapshot into `$HOME`.
5. Run `scripts/switch-home-manager.sh` to apply the declarative Home Manager layer.
6. Log out and back in so Plasma / Hyprland pick up everything cleanly.

## Notes

- The restore script uses `rsync` and excludes repo metadata.
- The app installer uses grouped manifests and can mix `sudo apt`, `flatpak`, and `nix profile install`.
- Some packages may not exist on a future distro release. Treat the manifests as the source of truth, not as a guarantee that every package name will stay valid forever.
- The most portable part of this repo is the Nix-managed Hyprland layer in `flake.nix`, `home.nix`, and `modules/`.

## Grouped installs

Examples:

```bash
./scripts/install-apps.sh desktop dev hypr
./scripts/install-apps.sh gaming creative
./scripts/install-apps.sh plasma system
```

Available groups:
- `desktop`
- `dev`
- `gaming`
- `science`
- `system`
- `plasma`
- `creative`
- `cosmic`
- `hypr`
