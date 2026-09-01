{
  description = "Taichi Ubuntu Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # Taichi is the only machine managed by this flake.
      # Run: home-manager switch --flake .#delai
      homeConfigurations.delai = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          user = "delai";
          dotfiles = "/home/delai/dotfiles";
        };

        modules = [
          ./home.nix
        ];
      };
    };
}
