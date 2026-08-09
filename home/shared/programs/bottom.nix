{
  config,
  lib,
  ...
}: let
  cfg = config.custom.bottom;
in {
  options.custom.bottom.enable = lib.mkEnableOption "bottom";
  config.programs.bottom = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      color = "nord";
      tree = true;
    };
  };
}
