{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.pnpm;
in {
  options.custom.pnpm.enable = lib.mkEnableOption "pnpm";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [pnpm];
    home.sessionVariables = {
      # pnpm
      PNPM_HOME = "$HOME/.local/share/pnpm";
    };
    home.sessionPath = ["$PNPM_HOME/bin"];
  };
}
