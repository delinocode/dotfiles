{
  description = "dotfiles";

  inputs = {
    # Use `github:NixOS/nixpkgs/nixpkgs-26.05-darwin` to use Nixpkgs 26.05.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    # Use `github:nix-darwin/nix-darwin/nix-darwin-26.05` to use Nixpkgs 26.05.
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # The standard (non-darwin) Nixpkgs branch; the host below builds
    # against it because the darwin branch is not intended for Linux.
    nixpkgs-linux.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.brew-src.url = "github:Homebrew/brew/master";
    };
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, home-manager, nixpkgs, nixpkgs-linux }:
    let
      # One username per machine.
      # bootstrap.sh and bootstrap-taichi.sh each offer to rewrite their
      # side if your actual username differs from what is configured here.
      macUser = "delino";
      taichiUser = "delai";
      taichiPkgs = import nixpkgs-linux {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
        specialArgs = { user = macUser; };
        modules = [
          ./configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { user = macUser; };
            home-manager.users.${macUser} = import ./home.nix;
          }
        ];
      };

      # Taichi (Ubuntu): standalone home-manager on a regular (non-NixOS)
      # system, managed with:
      #   home-manager switch --flake ~/.dotfiles#taichi
      homeConfigurations."taichi" = home-manager.lib.homeManagerConfiguration {
        pkgs = taichiPkgs;
        extraSpecialArgs = { user = taichiUser; };
        modules = [
          {
            home-manager.users.${taichiUser} = import ./home.nix;
          }
        ];
      };
    };
}
