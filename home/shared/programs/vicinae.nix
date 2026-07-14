{
  lib,
  pkgs,
  ...
}: {
  programs.vicinae = {
    enable = false;
    systemd = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
  };
}
