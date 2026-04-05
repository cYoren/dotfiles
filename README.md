# Gustavo's Private Dotfiles

Private backup of the current desktop setup and ricing.

Included here:
- Hyprland config
- Waybar, Wofi, Rofi, Kitty, Alacritty, Qt, GTK, and Starship config
- Nix home configuration
- Local Hyprland and wallpaper helper scripts
- Generated Catppuccin Mocha wallpaper assets

This repo is intentionally scoped to desktop configuration and wallpaper tooling, not the full home directory.

## Restore Notes

Copy the tracked files back into the same locations under `$HOME`, then re-run your normal Nix / Home Manager apply flow if needed.

Key paths:
- `.config/`
- `.local/bin/`
- `Pictures/wallpapers/`
- `home.nix`
- `flake.nix`
