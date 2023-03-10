{
  description = "my minimal flake";
  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixos-22.11

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # flake-utils
    flake-utils.url = "github:numtide/flake-utils";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    gpkg.url = "github:thekorn/gpkg";

    lazyvim.url = "github:thekorn/nvim-config";
    lazyvim.flake = false;
  };

outputs = inputs @ { self, flake-utils, darwin, vscode-server, deploy-rs, nixpkgs, nixpkgsUnstable, home-manager }:


    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {

          # nix develop
          # home-manager switch --flake .#mbp2020
          devShells = {
            default = with pkgs; mkShell {
              buildInputs = [
                pkgs.home-manager
              ];
            };
          };

        })
    // # <- concatenates Nix attribute sets
    {
      # TODO re-enable cachix across hosts

      homeConfigurations = {
        demoVM = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
          modules = [ ./nixpkgs/home-manager/demoVM.nix ];
          # extraModules = [ ./nixpkgs/home-manager/mac.nix ];
          extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.aarch64-darwin; };
          # system = "aarch64-darwin";
          # configuration = { };
          # homeDirectory = "/home/schickling";
          # username = "schickling";
        };


        #mbp2021 = inputs.home-manager.lib.homeManagerConfiguration {
        #  pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
        #  modules = [ ./nixpkgs/home-manager/mbp2021.nix ];
        #  # extraModules = [ ./nixpkgs/home-manager/mac.nix ];
        #  extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.aarch64-darwin; };
        #  # system = "aarch64-darwin";
        #  # configuration = { };
        #  # homeDirectory = "/home/schickling";
        #  # username = "schickling";
        #};
#
        #mbp2020 = inputs.home-manager.lib.homeManagerConfiguration {
        #  pkgs = inputs.nixpkgs.legacyPackages.x86_64-darwin;
        #  modules = [ ./nixpkgs/home-manager/mbp2020.nix ];
        #  # extraModules = [ ./nixpkgs/home-manager/mac.nix ];
        #  extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-darwin; };
        #  # system = "aarch64-darwin";
        #  # configuration = { };
        #  # homeDirectory = "/home/schickling";
        #  # username = "schickling";
        #};
#
        #dev2 = inputs.home-manager.lib.homeManagerConfiguration {
        #  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        #  modules = [ ./nixpkgs/home-manager/dev2.nix ];
        #  extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-linux; };
        #};
#
        #homepi = inputs.home-manager.lib.homeManagerConfiguration {
        #  pkgs = inputs.nixpkgs.legacyPackages.aarch64-linux;
        #  modules = [ ./nixpkgs/home-manager/homepi.nix ];
        #  extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.aarch64-linux; };
        #};
#
        #gitpod = inputs.home-manager.lib.homeManagerConfiguration {
        #  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        #  modules = [ ./nixpkgs/home-manager/gitpod.nix ];
        #  extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-linux; };
        #};

      };

      darwinConfigurations = {
        # nix build .#darwinConfigurations.mbp2021.system
        # ./result/sw/bin/darwin-rebuild switch --flake .
        # also requires running `chsh -s /run/current-system/sw/bin/fish` once
        demoVM = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./nixpkgs/darwin/demoVM/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.test = import ./nixpkgs/home-manager/demoVM.nix;
              home-manager.extraSpecialArgs = { inherit gpkg; inherit lazyvim; inherit nixpkgs; pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.aarch64-darwin; };
            }
          ];
          inputs = { inherit darwin nixpkgs; };
        };

        ## nix build .#darwinConfigurations.mbp2020.system
        ## ./result/sw/bin/darwin-rebuild switch --flake .
        ## also requires running `chsh -s /run/current-system/sw/bin/fish` once
        #mbp2020 = darwin.lib.darwinSystem {
        #  system = "x86_64-darwin";
        #  modules = [
        #    ./nixpkgs/darwin/mbp2020/configuration.nix
        #    home-manager.darwinModules.home-manager
        #    {
        #      home-manager.useGlobalPkgs = true;
        #      home-manager.useUserPackages = true;
        #      home-manager.users.schickling = import ./nixpkgs/home-manager/mbp2020.nix;
        #      home-manager.extraSpecialArgs = { inherit nixpkgs; pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-darwin; };
        #    }
        #  ];
        #  inputs = { inherit darwin nixpkgs; };
        #};
      };

      #nixosConfigurations = {
#
      #  # On actual machine: sudo nixos-rebuild switch --flake .#dev2
      #  # On other machine: nix run github:serokell/deploy-rs .#dev2
      #  dev2 = inputs.nixpkgs.lib.nixosSystem {
      #    system = "x86_64-linux";
      #    specialArgs = { common = self.common; pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-linux; inherit inputs; };
      #    modules = [
      #      ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; }) # Avoids nixpkgs checkout when running `nix run nixpkgs#hello`
      #      vscode-server.nixosModule
      #      ./nixpkgs/nixos/dev2/configuration.nix
      #      home-manager.nixosModules.home-manager
      #      {
      #        home-manager.useGlobalPkgs = true;
      #        home-manager.useUserPackages = true;
      #        home-manager.backupFileExtension = "backup";
      #        home-manager.extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-linux; };
      #        # TODO load home-manager dotfiles also for root user
      #        home-manager.users.schickling = import ./nixpkgs/home-manager/dev2.nix;
      #      }
      #    ];
      #  };
#
      #  build-server = inputs.nixpkgs.lib.nixosSystem {
      #    system = "aarch64-linux";
      #    specialArgs = { common = self.common; inherit inputs; };
      #    modules = [
      #      ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; }) # Avoids nixpkgs checkout when running `nix run nixpkgs#hello`
      #      ./nixpkgs/nixos/build-server/configuration.nix
      #      home-manager.nixosModules.home-manager
      #      {
      #        home-manager.useGlobalPkgs = true;
      #        home-manager.useUserPackages = true;
      #        home-manager.backupFileExtension = "backup";
      #        home-manager.extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.aarch64-linux; };
      #        home-manager.users.root = import ./nixpkgs/home-manager/nix-builder.nix;
      #      }
      #    ];
      #  };
#
      #  # sudo nixos-rebuild switch --flake .#homepi
      #  homepi = inputs.nixpkgs.lib.nixosSystem {
      #    system = "aarch64-linux";
      #    specialArgs = { common = self.common; inherit inputs; };
      #    modules = [
      #      ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; }) # Avoids nixpkgs checkout when running `nix run nixpkgs#hello`
      #      vscode-server.nixosModule
      #      ./nixpkgs/nixos/homepi/configuration.nix
      #      home-manager.nixosModules.home-manager
      #      {
      #        home-manager.useGlobalPkgs = true;
      #        home-manager.useUserPackages = true;
      #        home-manager.backupFileExtension = "backup";
      #        home-manager.extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.aarch64-linux; };
      #        # TODO load home-manager dotfiles also for root user
      #        home-manager.users.schickling = import ./nixpkgs/home-manager/homepi.nix;
      #      }
      #    ];
#
      #  };
#
      #};
#
      #images = {
      #  # nix build .#images.homepi
      #  homepi = self.nixosConfigurations.homepi.config.system.build.sdImage;
      #};
#
      #deploy.nodes = {
      #  homepi = {
      #    # hostname = "192.168.1.8"; # local ip
      #    hostname = "homepi";
      #    profiles.system = {
      #      sshUser = "root";
      #      path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.homepi;
      #    };
      #  };
#
      #  dev2 = {
      #    hostname = "dev2";
      #    profiles.system = {
      #      sshUser = "root";
      #      path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.dev2;
      #    };
      #  };
#
      #  build-server = {
      #    hostname = "oracle-nix-builder";
      #    profiles.system = {
      #      sshUser = "root";
      #      path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.build-server;
      #    };
      #  };
      #};
#
      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      common = {
        sshKeys = [
          #"ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLXMVzwr9BKB67NmxYDxedZC64/qWU6IvfTTh4HDdLaJe18NgmXh7mofkWjBtIy+2KJMMlB4uBRH4fwKviLXsSM= MBP2020@secretive.MacBook-Pro-Johannes.local"
          #"ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBM7UIxnOjfmhXMzEDA1Z6WxjUllTYpxUyZvNFpS83uwKj+eSNuih6IAsN4QAIs9h4qOHuMKeTJqanXEanFmFjG0= MM2021@secretive.Johannes’s-Mac-mini.local"
          #"ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPkfRqtIP8Lc7qBlJO1CsBeb+OEZN87X+ZGGTfNFf8V588Dh/lgv7WEZ4O67hfHjHCNV8ZafsgYNxffi8bih+1Q= MBP2021@secretive.Johannes’s-MacBook-Pro.local"
          #"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBY2vg6JN45hpcl9HH279/ityPEGGOrDjY3KdyulOUmX"
        ];
      };
    };
}




  #outputs = inputs@{ nixpkgs, home-manager, darwin, gpkg, lazyvim, ... }: {
  #  darwinConfigurations.test = darwin.lib.darwinSystem {
  #    system = "aarch64-darwin";
  #    pkgs = import nixpkgs { 
  #      system = "aarch64-darwin";
  #      config.allowUnfree = true; 
  #    };
  #    modules = [
  #      ./modules/darwin
  #      home-manager.darwinModules.home-manager
  #      {
  #        home-manager = {
  #          extraSpecialArgs = { inherit gpkg; inherit lazyvim; };
  #          useGlobalPkgs = true;
  #          useUserPackages = true;
  #          users.test.imports = [ 
  #            ./modules/home-manager
  #            ./modules/home/alacritty.nix
  #            ./modules/home/bat.nix
  #            ./modules/home/exa.nix
  #            ./modules/home/fzf.nix
  #            ./modules/home/git.nix
  #            ./modules/home/tmux.nix
  #            ./modules/home/zsh.nix
  #            ./modules/home/ssh.nix
  #          ];
  #        };
  #      }
  #    ];
  #  };
  #};
#}
#