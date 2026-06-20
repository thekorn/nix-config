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

    homeManagerModule = {
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bck";
    };

    mkDarwinHost = hostModule:
      darwin.lib.darwinSystem {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
          overlays = [llm-agents.overlays.default];
        };
        modules = [
          hostModule
          home-manager.darwinModules.home-manager
          homeManagerModule
        ];
        inherit specialArgs;
      };

    mkNixosHost = {
      system ? "x86_64-linux",
      hostModule,
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          hostModule
          home-manager.nixosModules.home-manager
          homeManagerModule
        ];
        inherit specialArgs;
      };
  in {
    formatter = eachSupportedSystem (system: legacyPackages.${system}.alejandra);

    darwinConfigurations."thekorn-macbook" = mkDarwinHost ./hosts/darwin/thekornMacbook.nix;

    darwinConfigurations."thekorn-studio" = mkDarwinHost ./hosts/darwin/thekornStudio.nix;

    darwinConfigurations."BFG-043556" = mkDarwinHost ./hosts/darwin/thekornWork.nix;

    nixosConfigurations.thekorn-server = mkNixosHost {
      hostModule = ./hosts/linux/thekorn-server.nix;
    };
  };
}
