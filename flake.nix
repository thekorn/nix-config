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
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      eachSupportedSystem = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];

      legacyPackages = eachSupportedSystem (system:
        import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = with inputs;
            [
              #nur.overlay
              #emacs.overlay
            ];
        });

      mkDarwinHost = darwin.lib.darwinSystem;
      #mkHome = home-manager.lib.homeManagerConfiguration;
    in {
      #homeManagerModules = import ./modules/home-manager;
      #darwinModules = import ./modules/host;

      devShells = eachSupportedSystem (system: {
        default = import ./shell.nix { pkgs = legacyPackages.${system}; };
      });

      formatter =
        eachSupportedSystem (system: legacyPackages.${system}.alejandra);

      darwinConfigurations."demoVM" = mkDarwinHost {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        modules = [
          ./hosts/darwin/demoVM.nix
          home-manager.darwinModules.home-manager
          ({ config, lib, pkgs, ... }:
            let primaryUser = "test";
            in {
              home-manager.extraSpecialArgs = { inherit self inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${primaryUser}.imports = [ ./home/demoVM.nix ];
            })
        ];
        specialArgs = { inherit self inputs; };
      };

      darwinConfigurations."thekorn-macbook" = mkDarwinHost {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        modules = [
          ./hosts/darwin/thekornMacbook.nix
          home-manager.darwinModules.home-manager
          ({ config, lib, pkgs, ... }:
            let primaryUser = "thekorn";
            in {
              home-manager.extraSpecialArgs = { inherit self inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${primaryUser}.imports =
                [ ./home/thekornMacbook.nix ];
            })
        ];
        specialArgs = { inherit self inputs; };
      };

      darwinConfigurations."thekorn-studio" = mkDarwinHost {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        modules = [
          ./hosts/darwin/thekornStudio.nix
          home-manager.darwinModules.home-manager
          ({ config, lib, pkgs, ... }:
            let primaryUser = "thekorn";
            in {
              home-manager.extraSpecialArgs = { inherit self inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${primaryUser}.imports =
                [ ./home/thekornStudio.nix ];
            })
        ];
        specialArgs = { inherit self inputs; };
      };

      darwinConfigurations."BFG-024849" = mkDarwinHost {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        modules = [
          ./hosts/darwin/thekornWork.nix
          home-manager.darwinModules.home-manager
          ({ config, lib, pkgs, ... }:
            let primaryUser = "d438477";
            in {
              home-manager.extraSpecialArgs = { inherit self inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${primaryUser}.imports =
                [ ./home/thekornWork.nix ];
            })
        ];
        specialArgs = { inherit self inputs; };
      };

      nixosConfigurations.thekorn-nixos-vm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/linux/thekornNixOSVM.nix
          home-manager.nixosModules.home-manager
          ({ config, lib, pkgs, ... }:
            let primaryUser = "thekorn";
            in {
              home-manager.extraSpecialArgs = { inherit self inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${primaryUser}.imports =
                [ ./home/thekornNixOSVM.nix ];
            })
        ];
        specialArgs = { inherit self inputs; };

      };

      nixosConfigurations.thekorn-nixos-workstation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/linux/thekorn-nixos-workstation.nix
          home-manager.nixosModules.home-manager
          ({ config, lib, pkgs, ... }:
            let primaryUser = "thekorn";
            in {
              home-manager.extraSpecialArgs = { inherit self inputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${primaryUser}.imports =
                [ ./home/thekornNixOSWorkstation.nix ];
            })
        ];
        specialArgs = { inherit self inputs; };

      };
    };
}
