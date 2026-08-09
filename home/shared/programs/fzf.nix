{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.fzf;
in {
  options.custom.fzf.enable = lib.mkEnableOption "fzf";
  config.programs.fzf = lib.mkIf cfg.enable {
    enable = true;
    enableZshIntegration = true;
    historyWidget.command = "";
  };
}
