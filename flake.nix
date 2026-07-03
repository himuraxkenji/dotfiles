{
  description = "himura's dotfiles (macOS + Linux, standalone Home Manager)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations.himura = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = builtins.currentSystem;
      };
      modules = [ ./home.nix ];
    };
  };
}
