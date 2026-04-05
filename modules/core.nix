{ ... }:

{
  home.username = "gustvmar";
  home.homeDirectory = "/home/gustvmar";
  home.stateVersion = "24.11";

  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
    BROWSER = "firefox";
  };
}
