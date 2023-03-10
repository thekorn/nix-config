{
  description = "My NixOS config";

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

  outputs = {
    self,
    nixpkgs,
    home-manager,
    gpkg,
    lazyvim,
    darwin,
    ...
  } @ inputs: let
    eachSupportedSystem = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-darwin"
    ];

    legacyPackages = eachSupportedSystem (system:
      import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
        overlays = with inputs; [
          #nur.overlay
          #emacs.overlay
        ];
      });

    mkDarwinHost = darwin.lib.darwinSystem;
    mkHome = home-manager.lib.homeManagerConfiguration;




    homeConfigurations."demoVM" = mkHome {
      pkgs = self.outputs.darwinConfigurations.demoVM.pkgs;
      modules = [./home/demoVM.nix];
      extraSpecialArgs = {inherit self inputs gpkg lazyvim;};
    };
  in {
    homeManagerModules = import ./modules/home-manager;
    darwinModules = import ./modules/host;

    devShells = eachSupportedSystem (system: {
      default = import ./shell.nix {pkgs = legacyPackages.${system};};
    });

    formatter = eachSupportedSystem (system: legacyPackages.${system}.alejandra);

    darwinConfigurations."demoVM" = mkDarwinHost {
      pkgs = import nixpkgs { 
        system = "aarch64-darwin";
        config.allowUnfree = true; 
      };
      modules = [
        ./hosts/darwin/demoVM.nix
        homeConfigurations."demoVM"
      ];
      specialArgs = {inherit self inputs;};
    };
  };
}
