{ config, lib, ... }:

let
  homeDir = config.home.homeDirectory;
  substHome = path:
    lib.replaceStrings [ "/home/gustvmar" ] [ homeDir ] (builtins.readFile path);
in {
  xdg.configFile."hypr/hyprland.conf".text = substHome ../.config/hypr/hyprland.conf;
  xdg.configFile."hypr/hyprpaper.conf".source = ../.config/hypr/hyprpaper.conf;
  xdg.configFile."hypr/hypridle.conf".source = ../.config/hypr/hypridle.conf;
  xdg.configFile."hypr/hyprlock.conf".text = substHome ../.config/hypr/hyprlock.conf;

  xdg.configFile."waybar/config".text = substHome ../.config/waybar/config;
  xdg.configFile."waybar/config.jsonc".text = substHome ../.config/waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ../.config/waybar/style.css;

  xdg.configFile."wofi/style.css".source = ../.config/wofi/style.css;
  xdg.configFile."rofi/config.rasi".source = ../.config/rofi/config.rasi;
  xdg.configFile."rofi/themes".source = ../.config/rofi/themes;
  xdg.configFile."rofi/themes".recursive = true;

  xdg.configFile."kitty/kitty.conf".source = ../.config/kitty/kitty.conf;
  xdg.configFile."alacritty/alacritty.toml".source = ../.config/alacritty/alacritty.toml;

  xdg.configFile."gtk-3.0/colors.css".source = ../.config/gtk-3.0/colors.css;
  xdg.configFile."gtk-3.0/gtk.css".source = ../.config/gtk-3.0/gtk.css;
  xdg.configFile."gtk-3.0/settings.ini".source = ../.config/gtk-3.0/settings.ini;
  xdg.configFile."gtk-3.0/window_decorations.css".source = ../.config/gtk-3.0/window_decorations.css;
  xdg.configFile."gtk-3.0/assets".source = ../.config/gtk-3.0/assets;
  xdg.configFile."gtk-3.0/assets".recursive = true;

  xdg.configFile."gtk-4.0/colors.css".source = ../.config/gtk-4.0/colors.css;
  xdg.configFile."gtk-4.0/gtk.css".source = ../.config/gtk-4.0/gtk.css;
  xdg.configFile."gtk-4.0/settings.ini".source = ../.config/gtk-4.0/settings.ini;
  xdg.configFile."gtk-4.0/window_decorations.css".source = ../.config/gtk-4.0/window_decorations.css;
  xdg.configFile."gtk-4.0/cosmic".source = ../.config/gtk-4.0/cosmic;
  xdg.configFile."gtk-4.0/cosmic".recursive = true;

  xdg.configFile."qt5ct/qt5ct.conf".text = substHome ../.config/qt5ct/qt5ct.conf;
  xdg.configFile."qt6ct/qt6ct.conf".text = substHome ../.config/qt6ct/qt6ct.conf;
  xdg.configFile."starship.toml".source = ../.config/starship.toml;

  xdg.configFile."kdeglobals".source = ../.config/kdeglobals;
  xdg.configFile."kglobalshortcutsrc".source = ../.config/kglobalshortcutsrc;
  xdg.configFile."konsolerc".source = ../.config/konsolerc;
  xdg.configFile."kwinrc".source = ../.config/kwinrc;
  xdg.configFile."kwinrulesrc".source = ../.config/kwinrulesrc;
  xdg.configFile."kcminputrc".source = ../.config/kcminputrc;
  xdg.configFile."kscreenlockerrc".text = substHome ../.config/kscreenlockerrc;
  xdg.configFile."plasma-org.kde.plasma.desktop-appletsrc".source = ../.config/plasma-org.kde.plasma.desktop-appletsrc;
  xdg.configFile."plasmashellrc".source = ../.config/plasmashellrc;
  xdg.configFile."powermanagementprofilesrc".source = ../.config/powermanagementprofilesrc;
  xdg.configFile."dolphinrc".source = ../.config/dolphinrc;
  xdg.configFile."kiorc".source = ../.config/kiorc;
  xdg.configFile."plasma-localerc".source = ../.config/plasma-localerc;
  xdg.configFile."ksmserverrc".source = ../.config/ksmserverrc;
  xdg.configFile."ksplashrc".source = ../.config/ksplashrc;
  xdg.configFile."mimeapps.list".source = ../.config/mimeapps.list;

  home.file.".config/gtkrc".source = ../.config/gtkrc;
  home.file.".config/gtkrc-2.0".source = ../.config/gtkrc-2.0;

  home.file.".local/bin/collect-hypr-debug".source = ../.local/bin/collect-hypr-debug;
  home.file.".local/bin/generate_ascii_wallpaper.py".source = ../.local/bin/generate_ascii_wallpaper.py;
  home.file.".local/bin/hypr-app-menu".source = ../.local/bin/hypr-app-menu;
  home.file.".local/bin/hypr-cheatsheet-menu".source = ../.local/bin/hypr-cheatsheet-menu;
  home.file.".local/bin/hypr-clipboard-menu".source = ../.local/bin/hypr-clipboard-menu;
  home.file.".local/bin/hypr-open-browser".source = ../.local/bin/hypr-open-browser;
  home.file.".local/bin/hypr-open-files".source = ../.local/bin/hypr-open-files;
  home.file.".local/bin/hypr-power-menu".source = ../.local/bin/hypr-power-menu;
  home.file.".local/bin/hypr-restart-waybar".source = ../.local/bin/hypr-restart-waybar;
  home.file.".local/bin/hypr-running-apps".source = ../.local/bin/hypr-running-apps;
  home.file.".local/bin/hypr-start-wallpaper".source = ../.local/bin/hypr-start-wallpaper;
  home.file.".local/bin/hyprland-session".source = ../.local/bin/hyprland-session;
  home.file.".local/bin/plasmawayland-session".source = ../.local/bin/plasmawayland-session;
  home.file.".local/bin/test-hyprland-amd-setup".source = ../.local/bin/test-hyprland-amd-setup;

  home.file."Pictures/wallpapers/ascii-mocha-spiral-seamless.mp4".source = ../Pictures/wallpapers/ascii-mocha-spiral-seamless.mp4;
  home.file."Pictures/wallpapers/ascii-mocha-design.mp4".source = ../Pictures/wallpapers/ascii-mocha-design.mp4;
  home.file."Pictures/wallpapers/ascii-mocha-falling-pink.mp4".source = ../Pictures/wallpapers/ascii-mocha-falling-pink.mp4;
  home.file."Pictures/wallpapers/ascii-mocha-spiral-slow.mp4".source = ../Pictures/wallpapers/ascii-mocha-spiral-slow.mp4;
  home.file."Pictures/wallpapers/catppuccin-mocha.png".source = ../Pictures/wallpapers/catppuccin-mocha.png;
}
