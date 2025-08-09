{
  description = "My NixOS config";

  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    microvm.url = "github:microvm-nix/microvm.nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    microvm,
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

    users = {
      private = "thekorn";
      work = "d438477";
    };

    # Import our library functions and machine definitions
    lib = import ./lib {
      inherit nixpkgs home-manager darwin microvm;
    };
    machines = import ./machines.nix;

    # Helper to create configurations with proper context
    mkConfigurations = configType: let
      filteredMachines = nixpkgs.lib.filterAttrs (_: machine: machine.type == configType) machines;
      mkFunction = if configType == "darwin" then lib.mkDarwinHost else lib.mkNixosHost;
    in
      nixpkgs.lib.mapAttrs (
        hostname: machine:
          mkFunction {
            inherit hostname;
            hostConfig = machine.hostConfig;
            user = machine.user;
            homeConfig = machine.homeConfig;
            profiles = machine.profiles or [];
            system = machine.system or (if configType == "darwin" then "aarch64-darwin" else "x86_64-linux");
            specialArgs = {inherit self inputs users;};
          }
      )
      filteredMachines;
  in {
    devShells = eachSupportedSystem (system: {
      default = import ./shell.nix {pkgs = legacyPackages.${system};};
    });

    formatter = eachSupportedSystem (system: legacyPackages.${system}.alejandra);

    darwinConfigurations = mkConfigurations "darwin";
    nixosConfigurations = mkConfigurations "nixos";
  };
}
