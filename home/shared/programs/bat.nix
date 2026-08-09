{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.bat;
in {
  options.custom.bat.enable = lib.mkEnableOption "bat";
  config = lib.mkIf cfg.enable {
    programs.bat.enable = true;
    programs.bat.config.theme = "Nord";
  };
}
