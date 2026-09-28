{
  description = "himura's dotfiles (macOS + Linux, standalone Home Manager)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:herdrdev/herdr/v0.9.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, herdr, ... }:
    let
      mkHome = system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; overlays = [ herdr.overlays.default ]; };
        modules = [
          ./home.nix
          ./modules/git.nix
          ./modules/starship.nix
          ./modules/fish.nix
          ./modules/tmux.nix
          ./modules/multiplexer.nix
          ./modules/herdr.nix
          ./modules/zellij.nix
          ./modules/ghostty.nix
          ./modules/nvim.nix
          ./modules/television.nix
          ./modules/opencode.nix
          ./modules/yabai.nix
          ./modules/skhd.nix
          ./modules/sketchybar.nix
          ./modules/sdkman.nix
        ];
      };
    in {
      homeConfigurations = {
        himura-darwin = mkHome "aarch64-darwin";
        himura-linux = mkHome "x86_64-linux";
      };
    };
}
