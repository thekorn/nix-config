{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.codebook;
in {
  options.custom.codebook.enable = lib.mkEnableOption "Codebook";
  config.home.packages = lib.mkIf cfg.enable [
    # FIXME: remove once nixpkgs supplies Codebook's system AWS-LC dependencies.
    # cargoSetupHook requires system libraries instead of the vendored copy.
    (pkgs.codebook.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [pkgs.pkg-config];
      buildInputs = (old.buildInputs or []) ++ [pkgs.aws-lc];
    }))
  ];
}
