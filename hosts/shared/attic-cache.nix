{
  config,
  lib,
  pkgs,
  ...
}: let
  cacheUrl = "http://thekorn-server.home:8080/home";
  publicKey = "home:+V4UmkDOcN3uktfI7DPSrdykyvxZDLnUJa2CJsJ3Otg=";
  darwinWithoutManagedNix = pkgs.stdenv.hostPlatform.isDarwin && !(config.nix.enable or false);
in
  lib.mkMerge [
    (lib.mkIf (!darwinWithoutManagedNix) {
      nix.settings = {
        extra-substituters = [cacheUrl];
        extra-trusted-public-keys = [publicKey];

        # The cache is available only on the home network. Fall back to
        # other substituters or local builds quickly when it is unreachable.
        connect-timeout = 2;
        fallback = true;
      };
    })

    (lib.mkIf darwinWithoutManagedNix {
      # Determinate Nix includes this file from /etc/nix/nix.conf. These
      # machines deliberately set nix.enable = false in nix-darwin.
      environment.etc."nix/nix.custom.conf".text = ''
        extra-substituters = ${cacheUrl}
        extra-trusted-public-keys = ${publicKey}
        connect-timeout = 2
        fallback = true
      '';
    })
  ]
