{
  mkDarwinHost,
  mkNixosHost,
  ...
}: {
  flake = {
    darwinConfigurations = {
      "thekorn-macbook" = mkDarwinHost ../hosts/darwin/thekornMacbook.nix;
      "thekorn-studio" = mkDarwinHost ../hosts/darwin/thekornStudio.nix;
      "BFG-043556" = mkDarwinHost ../hosts/darwin/thekornWork.nix;
    };

    nixosConfigurations = {
      thekorn-server = mkNixosHost {
        hostModule = ../hosts/linux/thekorn-server.nix;
      };

      thekorn-vm = mkNixosHost {
        hostModule = ../hosts/linux/thekorn-vm.nix;
      };
    };
  };
}
