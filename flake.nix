{
  description = "my minimal flake";
  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixos-22.11

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    gpkg.url = "github:thekorn/gpkg";

    lazyvim.url = "github:thekorn/nvim-config";
    lazyvim.flake = false;
  };
  outputs = inputs@{ nixpkgs, home-manager, darwin, gpkg, lazyvim, ... }: {
    darwinConfigurations.test = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = import nixpkgs { 
        system = "aarch64-darwin";
        config.allowUnfree = true; 
      };
      modules = [
        ./modules/darwin
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = { inherit gpkg; inherit lazyvim; };
            useGlobalPkgs = true;
            useUserPackages = true;
            users.test.imports = [ 
              ./modules/home-manager
              ./modules/home/alacritty.nix
              ./modules/home/bat.nix
              ./modules/home/exa.nix
              ./modules/home/fzf.nix
              ./modules/home/git.nix
              ./modules/home/tmux.nix
              ./modules/home/zsh.nix
            ];
          };
        }
      ];
    };
  };
}
