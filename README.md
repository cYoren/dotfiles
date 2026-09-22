# Gus's dotfiles

Personal configuration for **Omarchy 4 / Arch Linux + Hyprland** on a Dell G15 5525. The AMD 680M drives the laptop panel and the RTX 3050 drives HDMI.

The animated ASCII wallpaper is an Asciify Fluid canvas running as a separate Wayland background-layer process.

## What this repository restores

This is a configuration and package-selection backup, not a full disk image. It stores selected user configuration, scripts, package lists, NVIDIA module options, and notes for the kernel command line. It does not include personal files, application databases, browser profiles, credentials, or a copy of the installed operating system. Keep a separate encrypted backup of personal data and any required credentials.

Files under `.config/` and `.local/`, plus the checked-in shell startup files, mirror `$HOME`. `scripts/restore.sh` overlays only the paths in this repository; it does not delete unrelated files. Before replacing an existing tracked file, it saves the old version under `~/.local/state/dotfiles-restore-backups/`.

| Path | What |
|------|------|
| `.config/hypr/` | Omarchy Lua configuration and Hyprland overrides; `hyprland.lua` selects the AMD iGPU for VA-API/GLX |
| `.config/omarchy/` | Shell layout, theme, branding, and hooks |
| `.config/{alacritty,ghostty,kitty,foot}/` | Terminal settings |
| `.config/{nvim,tmux,btop,starship.toml,git/config}` | Editor and command-line tools |
| `.bashrc`, `.bash_profile`, `.profile`, `.zshrc` | Shell startup and local PATH setup |
| `.local/bin/env` and `.local/bin/env.fish` | PATH setup for Bash/Zsh and Fish |
| `.local/share/asciify-fluid/wallpaper.py` | Wallpaper window and rendering logic |
| `.local/bin/asciify-fluid-wallpaper.sh` | Alternative Chromium-based launcher |
| `.config/systemd/user/asciify-fluid-wallpaper.service` | Starts the wallpaper with the graphical session |
| `etc/modprobe.d/nvidia.conf` | NVIDIA runtime power management options; install manually as described below |
| `manifests/` | Explicitly installed native packages, foreign packages, and wallpaper runtime dependencies |
| `scripts/` | Restore and package-list capture helpers |
| `archive/` | Previous Debian, Plasma, Hyprland, and Nix setup |

## Restore on Omarchy / Arch

Start from a working Omarchy installation with network access, a configured user account, and an AUR helper such as `yay`. On a fresh Arch installation, configure the package repositories this machine uses (including Omarchy and BlackArch repositories where needed) before installing the package lists:

```bash
git clone https://github.com/cYoren/dotfiles.git ~/Documents/dotfiles
cd ~/Documents/dotfiles
sudo pacman -S --needed - < manifests/pacman-explicit.txt
yay -S --needed - < manifests/aur.txt
sudo pacman -S --needed - < manifests/runtime-dependencies.txt
./scripts/restore.sh --dry-run
./scripts/restore.sh
```

The package lists record package names, not package versions or repository snapshots. A future Arch mirror may no longer provide an old package name or version. `aur.txt` is generated from Pacman's explicitly installed foreign packages; that list can include packages from AUR helpers or other sources.

Install the system-level NVIDIA options if they are still appropriate for the machine:

```bash
sudo install -Dm644 etc/modprobe.d/nvidia.conf /etc/modprobe.d/nvidia.conf
```

The kernel command line used on this laptop is `acpi_backlight=native amdgpu.dcdebugmask=0x10`. Review the bootloader's current configuration before applying it. The wallpaper service is enabled by the restore script and starts when the graphical session is available. It requires `webkit2gtk-4.1`, `python-gobject`, and `gtk4-layer-shell`.

## Refresh package lists

After installing or removing software intentionally, update the checked-in package lists with:

```bash
./scripts/capture-manifests.sh
```

Review the resulting changes before committing. Do not add tokens, private keys, browser data, or other credentials to this public repository.

## Archive

- `archive/debian-plasma-hyprland-nix/` — previous Debian setup with KDE Plasma, Hyprland via Nix Home Manager, package manifests, and earlier ASCII wallpapers. See its README for that restore flow.
