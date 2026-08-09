{
  config,
  lib,
  ...
}: let
  cfg = config.custom.lazygit;
in {
  options.custom.lazygit.enable = lib.mkEnableOption "lazygit";
  config.programs.lazygit = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      gui = {
        showIcons = true;
        showRandomTip = false;
        notARepository = "quit";
      };
    };
  };
}
