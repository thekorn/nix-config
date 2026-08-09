{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.bun;
in {
  options.custom.bun.enable = lib.mkEnableOption "bun";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [bun];
    home.sessionPath = [
      "$HOME/.bun/bin"
    ];
  };
}
