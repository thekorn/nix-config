{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.zig;
in {
  options.custom.zig.enable = lib.mkEnableOption "Zig";
  config.home.packages = lib.mkIf cfg.enable (with pkgs; [zig zls]);
}
