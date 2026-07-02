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

    config-nvim = {
      url = "github:thekorn/config.nvim";
      flake = false;
    };

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
          overlays = [vendoredPackagesOverlay];
          config = {
            allowUnfree = true;
          };
        }
    );

    vendoredPackagesOverlay = final: prev: {
      vendored =
        (prev.vendored or {})
        // {
          container = final.callPackage ./pkgs/vendored/container.nix {};
        };
    };

    users = {
      private = "thekorn";
      work = "d438477";
    };

    specialArgs = {
      inherit self inputs users;
    };

    hostMeta = {
      thekorn-server = {
        targetHost = "thekorn-server.home";
        user = users.private;
      };
      thekorn-server-2 = {
        targetHost = "thekorn-server-2.home";
        user = users.private;
      };
      thekorn-vm = {
        targetHost = "thekorn-vm";
        user = users.private;
      };
      thekorn-vm-desktop = {
        targetHost = "thekorn-vm-desktop";
        user = users.private;
      };
      thekorn-vm-utm = {
        targetHost = "192.168.64.4"; #"thekorn-vm-utm";
        user = users.private;
      };
    };

    homeManagerModule = {
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bck";
      home-manager.sharedModules = [
        {
          manual.manpages.enable = false;
        }
      ];
    };

    darwinBaseModule = {pkgs, ...}: {
      system.stateVersion = 5;

      programs.zsh.enable = true;

      environment = {
        shells = with pkgs; [bash zsh];
        systemPackages = [pkgs.coreutils];
        systemPath = ["/opt/homebrew/bin"];
        pathsToLink = ["/Applications"];
      };

      nix.settings.experimental-features = ["nix-command" "flakes"];
    };

    mkDarwinHost = hostModule:
      darwin.lib.darwinSystem {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
          overlays = [
            llm-agents.overlays.default
            vendoredPackagesOverlay
          ];
        };
        modules = [
          darwinBaseModule
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
          {
            nixpkgs.overlays = [vendoredPackagesOverlay];
          }
          hostModule
          home-manager.nixosModules.home-manager
          homeManagerModule
        ];
        inherit specialArgs;
      };
  in {
    formatter = eachSupportedSystem (system: legacyPackages.${system}.alejandra);

    packages = eachSupportedSystem (system: let
      pkgs = legacyPackages.${system};
      server = hostMeta.thekorn-server;
      server2 = hostMeta.thekorn-server-2;
      vm = hostMeta.thekorn-vm;
      vmDesktop = hostMeta.thekorn-vm-desktop;
      utmDesktop = hostMeta.thekorn-vm-utm;
      deployNixConf = pkgs.writeTextDir "nix.conf" ''
        extra-experimental-features = nix-command flakes
      '';
    in {
      deploy-thekorn-server = pkgs.writeShellApplication {
        name = "deploy-thekorn-server";
        runtimeInputs = with pkgs; [nixos-rebuild openssh];
        text = ''
          export NIX_CONF_DIR="${deployNixConf}"
          flake_ref="''${NIX_CONFIG_FLAKE:-${self}}"

          exec nixos-rebuild switch \
            --flake "$flake_ref#thekorn-server" \
            --target-host "${server.user}@${server.targetHost}" \
            --build-host "${server.user}@${server.targetHost}" \
            --elevate=sudo \
            --ask-elevate-password \
            "$@"
        '';
      };

      deploy-thekorn-server-2 = pkgs.writeShellApplication {
        name = "deploy-thekorn-server-2";
        runtimeInputs = with pkgs; [nixos-rebuild openssh];
        text = ''
          export NIX_CONF_DIR="${deployNixConf}"
          flake_ref="''${NIX_CONFIG_FLAKE:-${self}}"

          exec nixos-rebuild switch \
            --flake "$flake_ref#thekorn-server-2" \
            --target-host "${server2.user}@${server2.targetHost}" \
            --build-host "${server2.user}@${server2.targetHost}" \
            --elevate=sudo \
            --ask-elevate-password \
            "$@"
        '';
      };

      deploy-thekorn-vm = pkgs.writeShellApplication {
        name = "deploy-thekorn-vm";
        runtimeInputs = with pkgs; [nixos-rebuild openssh];
        text = ''
          export NIX_CONF_DIR="${deployNixConf}"
          flake_ref="''${NIX_CONFIG_FLAKE:-${self}}"

          exec nixos-rebuild switch \
            --flake "$flake_ref#thekorn-vm" \
            --target-host "${vm.user}@${vm.targetHost}" \
            --build-host "${vm.user}@${vm.targetHost}" \
            --elevate=sudo \
            --ask-elevate-password \
            "$@"
        '';
      };

      deploy-thekorn-vm-desktop = pkgs.writeShellApplication {
        name = "deploy-thekorn-vm-desktop";
        runtimeInputs = with pkgs; [nixos-rebuild openssh];
        text = ''
          export NIX_CONF_DIR="${deployNixConf}"
          flake_ref="''${NIX_CONFIG_FLAKE:-${self}}"

          exec nixos-rebuild switch \
            --flake "$flake_ref#thekorn-vm-desktop" \
            --target-host "${vmDesktop.user}@${vmDesktop.targetHost}" \
            --build-host "${vmDesktop.user}@${vmDesktop.targetHost}" \
            --elevate=sudo \
            --ask-elevate-password \
            "$@"
        '';
      };

      deploy-thekorn-vm-utm = pkgs.writeShellApplication {
        name = "deploy-thekorn-vm-utm";
        runtimeInputs = with pkgs; [nixos-rebuild openssh];
        text = ''
          export NIX_CONF_DIR="${deployNixConf}"
          flake_ref="''${NIX_CONFIG_FLAKE:-${self}}"

          exec nixos-rebuild switch \
            --flake "$flake_ref#thekorn-vm-utm" \
            --target-host "${utmDesktop.user}@${utmDesktop.targetHost}" \
            --build-host "${utmDesktop.user}@${utmDesktop.targetHost}" \
            --elevate=sudo \
            --ask-elevate-password \
            "$@"
        '';
      };
    });

    apps = eachSupportedSystem (system: {
      deploy-thekorn-server = {
        type = "app";
        program = "${self.packages.${system}.deploy-thekorn-server}/bin/deploy-thekorn-server";
      };
      deploy-thekorn-server-2 = {
        type = "app";
        program = "${self.packages.${system}.deploy-thekorn-server-2}/bin/deploy-thekorn-server-2";
      };
      deploy-thekorn-vm = {
        type = "app";
        program = "${self.packages.${system}.deploy-thekorn-vm}/bin/deploy-thekorn-vm";
      };
      deploy-thekorn-vm-desktop = {
        type = "app";
        program = "${self.packages.${system}.deploy-thekorn-vm-desktop}/bin/deploy-thekorn-vm-desktop";
      };
      deploy-thekorn-vm-utm = {
        type = "app";
        program = "${self.packages.${system}.deploy-thekorn-vm-utm}/bin/deploy-thekorn-vm-utm";
      };
    });

    darwinConfigurations."thekorn-macbook" = mkDarwinHost ./hosts/darwin/thekornMacbook.nix;

    darwinConfigurations."thekorn-studio" = mkDarwinHost ./hosts/darwin/thekornStudio.nix;

    darwinConfigurations."BFG-043556" = mkDarwinHost ./hosts/darwin/thekornWork.nix;

    nixosConfigurations.thekorn-server = mkNixosHost {
      hostModule = ./hosts/linux/thekorn-server.nix;
    };

    nixosConfigurations.thekorn-server-2 = mkNixosHost {
      hostModule = ./hosts/linux/thekorn-server-2.nix;
    };

    nixosConfigurations.thekorn-vm = mkNixosHost {
      hostModule = ./hosts/linux/thekorn-vm.nix;
    };

    nixosConfigurations.thekorn-vm-desktop = mkNixosHost {
      hostModule = ./hosts/linux/thekorn-vm-desktop.nix;
    };

    nixosConfigurations.thekorn-vm-utm = mkNixosHost {
      hostModule = ./hosts/linux/thekorn-vm-utm.nix;
    };
  };
}
