{
  config,
  lib,
  ...
}: let
  cfg = config.custom.eza;
in {
  options.custom.eza.enable = lib.mkEnableOption "eza";
  config = lib.mkIf cfg.enable {programs.eza.enable = true;};
}
