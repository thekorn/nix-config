{
  config,
  lib,
  ...
}: let
  cfg = config.custom.fvm;
in {
  options.custom.fvm.enable = lib.mkEnableOption "FVM";
  config.home.sessionVariables = lib.mkIf cfg.enable {
    FVM_CACHE_PATH = "$HOME/.local/state/fvm";
  };
}
