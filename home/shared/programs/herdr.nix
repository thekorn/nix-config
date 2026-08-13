{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.herdr;
in {
  options.custom.herdr.enable = lib.mkEnableOption "Herdr";
  config = lib.mkIf cfg.enable {
    programs.herdr = {
      enable = true;
      package = pkgs.llm-agents.herdr;
    };
  };
}
