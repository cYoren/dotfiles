{
  description = "Gustavo's desktop dotfiles and portable Hyprland setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-guiutils = {
      url = "github:hyprwm/hyprland-guiutils";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, hyprland, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations.gustvmar = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          hyprland.homeManagerModules.default
          ./home.nix
        ];
      };
    };
}
