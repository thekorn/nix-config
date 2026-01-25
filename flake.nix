{
  description = "My NixOS config";

  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    #nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/ed142ab"; #swift 5.10.1 is broken on newer builds

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    omarchy-nix = {
      # url = "github:thekorn/omarchy-nix";
      url = "path:/home/thekorn/.config/omarchy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    self,
    nixpkgs,
    omarchy-nix,
    home-manager,
    darwin,
    ...
  } @ inputs: let
    eachSupportedSystem = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-darwin"
      "aarch64-linux"
    ];

    legacyPackages = eachSupportedSystem (
      system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        }
    );

    mkDarwinHost = darwin.lib.darwinSystem;

    users = {
      private = "thekorn";
      work = "d438477";
    };
  in {
    formatter = eachSupportedSystem (system: legacyPackages.${system}.alejandra);

    darwinConfigurations."thekorn-macbook" = mkDarwinHost {
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
      modules = [
        ./hosts/darwin/thekornMacbook.nix
        home-manager.darwinModules.home-manager
        (
          {...}: let
            primaryUser = users.private;
          in {
            home-manager.extraSpecialArgs = {
              inherit self inputs;
              inherit users;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${primaryUser}.imports = [./home/thekornMacbook.nix];
          }
        )
      ];
      specialArgs = {
        inherit self inputs;
        inherit users;
      };
    };

    darwinConfigurations."thekorn-studio" = mkDarwinHost {
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
      modules = [
        ./hosts/darwin/thekornStudio.nix
        home-manager.darwinModules.home-manager
        (
          {...}: let
            primaryUser = users.private;
          in {
            home-manager.extraSpecialArgs = {
              inherit self inputs;
              inherit users;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${primaryUser}.imports = [./home/thekornStudio.nix];
          }
        )
      ];
      specialArgs = {
        inherit self inputs;
        inherit users;
      };
    };

    darwinConfigurations."BFG-024849" = mkDarwinHost {
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
      modules = [
        ./hosts/darwin/thekornWork.nix
        home-manager.darwinModules.home-manager
        (
          {...}: let
            primaryUser = users.work;
          in {
            home-manager.extraSpecialArgs = {
              inherit self inputs;
              inherit users;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${primaryUser}.imports = [./home/thekornWork.nix];
          }
        )
      ];
      specialArgs = {
        inherit self inputs;
        inherit users;
      };
    };

    nixosConfigurations.thekorn-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        omarchy-nix.nixosModules.default
        ./hosts/linux/thekorn-server.nix
        {
          # Required configuration
          omarchy = {
            username = "thekorn";
            full_name = "thekorn";
            email_address = "hello@thekorn.dev";
            theme = "tokyo-night";
            seamless_boot = {
              enable = true; # Enable Plymouth + auto-login
              username = "thekorn"; # Required for auto-login
              plymouth_theme = "omarchy"; # Custom boot splash theme
              silent_boot = true; # Hide kernel messages
            };
          };

          # Home Manager integration
          home-manager.users.thekorn = {
            imports = [omarchy-nix.homeManagerModules.default];
          };
        }
        home-manager.nixosModules.home-manager
        (
          {...}: let
            primaryUser = users.private;
          in {
            home-manager.extraSpecialArgs = {
              inherit self inputs;
              inherit users;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${primaryUser}.imports = [./home/thekornServer.nix];
          }
        )
      ];
      specialArgs = {
        inherit self inputs;
        inherit users;
      };
    };

    nixosConfigurations.thekorn-server2 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/linux/thekorn-server2.nix
        home-manager.nixosModules.home-manager
        (
          {...}: let
            primaryUser = users.private;
          in {
            home-manager.extraSpecialArgs = {
              inherit self inputs;
              inherit users;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${primaryUser}.imports = [./home/thekornServer2.nix];
          }
        )
      ];
      specialArgs = {
        inherit self inputs;
        inherit users;
      };
    };
  };
}
