{
  description = "My NixOS config";

  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/2175e5c";

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    omarchy-nix = {
      url = "github:thekorn/omarchy-nix";
      #url = "path:/home/thekorn/.config/omarchy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = {
    self,
    nixpkgs,
    omarchy-nix,
    home-manager,
    darwin,
    llm-agents,
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

    users = {
      private = "thekorn";
      work = "d438477";
    };

    commonSpecialArgs = {
      inherit self inputs users;
    };

    mkDarwinHost = {
      hostModule,
      homeModule,
      user,
      system ? "aarch64-darwin",
      extraModules ? [],
    }:
      darwin.lib.darwinSystem {
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [llm-agents.overlays.default];
        };
        modules =
          [
            hostModule
            home-manager.darwinModules.home-manager
            ({...}: {
              home-manager = {
                extraSpecialArgs = commonSpecialArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user}.imports = [homeModule];
              };
            })
          ]
          ++ extraModules;
        specialArgs =
          commonSpecialArgs
          // {
            primaryUser = user;
          };
      };

    mkNixOSHost = {
      hostModule,
      homeModule,
      user,
      system ? "x86_64-linux",
      extraModules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          [
            hostModule
            home-manager.nixosModules.home-manager
            ({...}: {
              home-manager = {
                extraSpecialArgs = commonSpecialArgs;
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user}.imports = [homeModule];
              };
            })
          ]
          ++ extraModules;
        specialArgs =
          commonSpecialArgs
          // {
            primaryUser = user;
          };
      };
  in {
    formatter = eachSupportedSystem (system: legacyPackages.${system}.alejandra);

    darwinConfigurations."thekorn-macbook" = mkDarwinHost {
      user = users.private;
      hostModule = ./hosts/darwin/thekornMacbook.nix;
      homeModule = ./home/thekornMacbook.nix;
    };

    darwinConfigurations."thekorn-studio" = mkDarwinHost {
      user = users.private;
      hostModule = ./hosts/darwin/thekornStudio.nix;
      homeModule = ./home/thekornStudio.nix;
    };

    darwinConfigurations."BFG-024849" = mkDarwinHost {
      user = users.work;
      hostModule = ./hosts/darwin/thekornWork.nix;
      homeModule = ./home/thekornWork.nix;
    };

    nixosConfigurations.thekorn-server = mkNixOSHost {
      user = users.private;
      hostModule = ./hosts/linux/thekorn-server.nix;
      homeModule = ./home/thekornServer.nix;
      extraModules = [
        omarchy-nix.nixosModules.default
        ({primaryUser, ...}: {
          omarchy = {
            username = primaryUser;
            full_name = "Markus Korn";
            email_address = "markus.korn@gmail.com";
            theme = "tokyo-night";
            seamless_boot = {
              enable = true;
              username = primaryUser;
              plymouth_theme = "omarchy";
              silent_boot = true;
            };
            monitors = [
              "HDMI-A-1,3140x2610,auto,1"
            ];
            firewall = {
              enable = true;
            };
            quick_app_bindings = [
              "ALT_L, RETURN, Terminal, exec, $terminal"
              "ALT_L, SPACE, Launch apps, exec, omarchy-launch-walker"
              "ALT_L, K, Show key bindings, exec, omarchy-show-keybindings"
            ];
          };

          home-manager.users.${primaryUser} = {
            imports = [omarchy-nix.homeManagerModules.default];
          };
        })
      ];
    };

    nixosConfigurations.thekorn-server2 = mkNixOSHost {
      user = users.private;
      hostModule = ./hosts/linux/thekorn-server2.nix;
      homeModule = ./home/thekornServer2.nix;
    };
  };
}
