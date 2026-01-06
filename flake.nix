{
  description = "My NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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

    mkDarwinHost = darwin.lib.darwinSystem;

    lib = nixpkgs.lib;

    mkHost = { system, name, user, systemModules, homeModule }:
      let
        isDarwin = lib.hasSuffix "-darwin" system;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        baseSystem = if isDarwin then mkDarwinHost else nixpkgs.lib.nixosSystem;
        systemArgs = {
          modules = (if builtins.isList systemModules then systemModules else [systemModules])
            ++ [
              home-manager.${if isDarwin then "darwinModules" else "nixosModules"}.home-manager
              {
                home-manager.extraSpecialArgs = { inherit self inputs users; };
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${user}.imports = [homeModule];
              }
            ];
          specialArgs = { inherit self inputs users; };
        };
      in
      if isDarwin then
        baseSystem (systemArgs // { inherit pkgs; })
      else
        baseSystem systemArgs;

    darwinSystem = { name, user }:
      mkHost {
        inherit name user;
        system = "aarch64-darwin";
        systemModules = ./hosts/darwin/${name}.nix;
        homeModule = ./home/${name}.nix;
      };

    linuxSystem = { name, user }:
      let
        homeName = if name == "thekorn-server" then "thekornServer" else
                   if name == "thekorn-server2" then "thekornServer2" else name;
      in
      mkHost {
        inherit name user;
        system = "x86_64-linux";
        systemModules = [
          microvm.nixosModules.host
          ./hosts/linux/${name}.nix
        ];
        homeModule = ./home/${homeName}.nix;
      };
  in {
    formatter = eachSupportedSystem (system: legacyPackages.${system}.alejandra);

    darwinConfigurations = {
      "thekorn-macbook" = darwinSystem { name = "thekorn-macbook"; user = users.private; };
      "thekorn-studio" = darwinSystem { name = "thekorn-studio"; user = users.private; };
      "BFG-024849" = darwinSystem { name = "thekornWork"; user = users.work; };
    };

    nixosConfigurations = {
      "thekorn-server" = linuxSystem { name = "thekorn-server"; user = users.private; };
      "thekorn-server2" = linuxSystem { name = "thekorn-server2"; user = users.private; };
    };
  };
}
