{
  hostMeta,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    server = hostMeta.thekorn-server;
    vm = hostMeta.thekorn-vm;
  in {
    packages = {
      deploy-thekorn-server = pkgs.writeShellApplication {
        name = "deploy-thekorn-server";
        runtimeInputs = with pkgs; [nixos-rebuild openssh];
        text = ''
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

      deploy-thekorn-vm = pkgs.writeShellApplication {
        name = "deploy-thekorn-vm";
        runtimeInputs = with pkgs; [nixos-rebuild openssh];
        text = ''
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
    };

    apps = {
      deploy-thekorn-server = {
        type = "app";
        program = "${self'.packages.deploy-thekorn-server}/bin/deploy-thekorn-server";
        meta.description = "Deploy the thekorn-server NixOS configuration remotely";
      };
      deploy-thekorn-vm = {
        type = "app";
        program = "${self'.packages.deploy-thekorn-vm}/bin/deploy-thekorn-vm";
        meta.description = "Deploy the thekorn-vm NixOS configuration remotely";
      };
    };
  };
}
