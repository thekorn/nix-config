{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.codebook;
in {
  options.custom.codebook.enable = lib.mkEnableOption "Codebook";
  config.home.packages = lib.mkIf cfg.enable (with pkgs; [codebook]);
}
