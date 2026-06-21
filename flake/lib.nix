{
  inputs,
  self,
  ...
}: let
  users = {
    private = "thekorn";
    work = "d438477";
  };

  specialArgs = {
    inherit self inputs users;
  };

  mkPkgs = system:
    import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

  hostMeta = {
    thekorn-server = {
      targetHost = "thekorn-server.home";
      user = users.private;
    };
    thekorn-vm = {
      targetHost = "thekorn-vm";
      user = users.private;
    };
  };

  homeManagerModule = {
    home-manager.extraSpecialArgs = specialArgs;
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "bck";
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
    inputs.darwin.lib.darwinSystem {
      pkgs = import inputs.nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
        overlays = [inputs.llm-agents.overlays.default];
      };
      modules = [
        darwinBaseModule
        hostModule
        inputs.home-manager.darwinModules.home-manager
        homeManagerModule
      ];
      inherit specialArgs;
    };

  mkNixosHost = {
    system ? "x86_64-linux",
    hostModule,
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        hostModule
        inputs.home-manager.nixosModules.home-manager
        homeManagerModule
      ];
      inherit specialArgs;
    };
in {
  _module.args = {
    inherit hostMeta mkDarwinHost mkNixosHost mkPkgs users;
  };
}
