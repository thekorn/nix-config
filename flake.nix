{
  description = "My NixOS config";

  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/2175e5c";
    #nixpkgs.url = "github:nixos/nixpkgs/master";

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
    workmux.url = "github:raine/workmux";

    hunk = {
      url = "github:modem-dev/hunk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
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

    specialArgs = {
      inherit self inputs users;
    };

    mkHomeManagerModule = user: {
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user}.imports = [];
      home-manager.backupFileExtension = "bck";
    };

    mkDarwinHost = {
      user ? users.private,
      hostModule,
      homeModule,
    }:
      darwin.lib.darwinSystem {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
          overlays = [llm-agents.overlays.default];
        };
        modules = [
          hostModule
          home-manager.darwinModules.home-manager
          (mkHomeManagerModule user)
          {
            home-manager.users.${user}.imports = [homeModule];
          }
        ];
        inherit specialArgs;
      };

    mkNixosHost = {
      user ? users.private,
      system ? "x86_64-linux",
      hostModule,
      homeModule,
      extraModules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          extraModules
          ++ [
            hostModule
            home-manager.nixosModules.home-manager
            (mkHomeManagerModule user)
            {
              home-manager.users.${user}.imports = [homeModule];
            }
          ];
        inherit specialArgs;
      };
  in {
    formatter = eachSupportedSystem (system: legacyPackages.${system}.alejandra);

    darwinConfigurations."thekorn-macbook" = mkDarwinHost {
      hostModule = ./hosts/darwin/thekornMacbook.nix;
      homeModule = ./home/thekornMacbook.nix;
    };

    darwinConfigurations."thekorn-studio" = mkDarwinHost {
      hostModule = ./hosts/darwin/thekornStudio.nix;
      homeModule = ./home/thekornStudio.nix;
    };

    darwinConfigurations."BFG-043556" = mkDarwinHost {
      user = users.work;
      hostModule = ./hosts/darwin/thekornWork.nix;
      homeModule = ./home/thekornWork.nix;
    };

    nixosConfigurations.thekorn-server = mkNixosHost {
      hostModule = ./hosts/linux/thekorn-server.nix;
      homeModule = ./home/thekornServer.nix;
      extraModules = [
        inputs.omarchy-nix.nixosModules.default
        ({...}: let
          primaryUser = users.private;
        in {
          # Required configuration
          omarchy = {
            username = primaryUser;
            full_name = "Markus Korn";
            email_address = "markus.korn@gmail.com";
            theme = "tokyo-night";
            seamless_boot = {
              enable = true; # Enable Plymouth + auto-login
              username = primaryUser; # Required for auto-login
              plymouth_theme = "omarchy"; # Custom boot splash theme
              silent_boot = true; # Hide kernel messages
            };
            monitors = [
              #              "HDMI-A-1,2560x1440,auto,1,transform,1" # External monitor, 1x scaling, rotate 90deg
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

          # Home Manager integration
          home-manager.users.${primaryUser} = {
            imports = [inputs.omarchy-nix.homeManagerModules.default];
          };
        })
      ];
    };

    nixosConfigurations.thekorn-server2 = mkNixosHost {
      hostModule = ./hosts/linux/thekorn-server2.nix;
      homeModule = ./home/thekornServer2.nix;
    };
  };
}
