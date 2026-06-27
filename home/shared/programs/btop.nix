{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.btop;
in {
  options.custom.btop.theme = lib.mkOption {
    type = lib.types.str;
    default = "nord";
    description = "Color theme for btop.";
  };

  config = {
    home.file.".config/btop/themes".source = "${pkgs.btop}/share/btop/themes";

    programs.btop = {
      enable = true;
      settings = {
        color_theme = cfg.theme;
        theme_background = false;
      };
    };
  };
}
