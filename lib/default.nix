{
  nixpkgs,
  home-manager,
  darwin,
  microvm,
  ...
}: rec {
  # Helper to create Darwin configurations
  mkDarwinHost = {
    hostname,
    hostConfig,
    user,
    homeConfig,
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
          ../hosts/darwin/${hostConfig}.nix
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
        ++ modules;
      inherit specialArgs;
    };

  # Helper to create NixOS configurations
  mkNixosHost = {
    hostname,
    hostConfig,
    user,
    homeConfig,
    system ? "x86_64-linux",
    modules ? [],
    specialArgs ? {},
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [
          microvm.nixosModules.host
          ../hosts/linux/${hostConfig}.nix
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
        ++ modules;
      inherit specialArgs;
    };
}