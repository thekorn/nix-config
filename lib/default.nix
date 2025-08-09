{
  nixpkgs,
  home-manager,
  darwin,
  microvm,
  ...
}: rec {
  # Helper to load profiles based on machine configuration
  loadProfiles = {
    profiles,
    platform, # "darwin" or "nixos"
  }: let
    # Load shared profiles that exist
    sharedProfiles = nixpkgs.lib.filter (path: builtins.pathExists path) (
      map (profile: ../profiles/shared/${profile}.nix) profiles
    );
    # Load platform-specific profiles if they exist
    platformProfiles = nixpkgs.lib.filter (path: builtins.pathExists path) (
      map (profile: ../profiles/${platform}/${profile}.nix) profiles
    );
  in
    sharedProfiles ++ platformProfiles;

  # Helper to create Darwin configurations
  mkDarwinHost = {
    hostname,
    hostConfig,
    user,
    homeConfig,
    profiles ? [],
    system ? "aarch64-darwin",
    modules ? [],
    specialArgs ? {},
  }:
    darwin.lib.darwinSystem {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      modules =
        [
          ../modules/darwin-base.nix
          home-manager.darwinModules.home-manager
          ({...}: {
            home-manager = {
              extraSpecialArgs = specialArgs;
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user}.imports = [../home/${homeConfig}.nix];
            };
          })
        ]
        ++ (loadProfiles {
          inherit profiles;
          platform = "darwin";
        })
        ++ modules;
      inherit specialArgs;
    };

  # Helper to create NixOS configurations
  mkNixosHost = {
    hostname,
    hostConfig,
    user,
    homeConfig,
    profiles ? [],
    system ? "x86_64-linux",
    modules ? [],
    specialArgs ? {},
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [
          microvm.nixosModules.host
          ../modules/nixos-base.nix
          home-manager.nixosModules.home-manager
          ({...}: {
            home-manager = {
              extraSpecialArgs = specialArgs;
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user}.imports = [../home/${homeConfig}.nix];
            };
          })
        ]
        ++ (loadProfiles {
          inherit profiles;
          platform = "nixos";
        })
        ++ modules;
      inherit specialArgs;
    };
}