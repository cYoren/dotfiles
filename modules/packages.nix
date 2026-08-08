{ pkgs, inputs, ... }:

let
  hyprlandGuiutils = inputs.hyprland-guiutils.packages.${pkgs.system}.default;
in {
  home.packages = with pkgs; [
    alacritty
    bat
    brightnessctl
    btop
    cliphist
    delta
    eza
    fd
    fzf
    git
    grimblast
    hypridle
    hyprlock
    hyprpaper
    hyprland
    hyprlandGuiutils
    kitty
    mako
    mpv
    mpvpaper
    networkmanagerapplet
    playerctl
    pavucontrol
    ripgrep
    rofi
    starship
    swappy
    swaynotificationcenter
    swww
    tmux
    waybar
    wl-clipboard
    wofi
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xdg-utils
    yazi
    zoxide
  ];
}
