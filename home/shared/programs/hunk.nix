{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.hunk;
in {
  imports = [
    (inputs.hunk + "/nix/home-manager.nix")
  ];

  options.custom.hunk.package = lib.mkOption {
    type = lib.types.nullOr lib.types.package;
    # move to inputs.hunk.packages.${pkgs.stdenv.hostPlatform.system}.default eventually
    default = pkgs.vendored.hunk;
    description = ''
      Hunk package to install. Defaults to the vendored prebuilt package, which
      avoids an unrelated x86_64-darwin deprecation warning during darwin-rebuild.
      Set to null to use the upstream module's default package.
    '';
  };

  config.programs.hunk =
    {
      enable = true;
      enableGitIntegration = false;
      settings = {
        theme = "github-dark-default";
        mode = "split";
        line_numbers = true;
      };
    }
    // lib.optionalAttrs (cfg.package != null) {
      package = cfg.package;
    };
}
