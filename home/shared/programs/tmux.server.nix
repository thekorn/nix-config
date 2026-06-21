{
  config,
  lib,
  ...
}: let
  cfg = config.custom.tmux.server;
in {
  imports = [./tmux.common.nix];

  options.custom.tmux.server = {
    statusBarBackgroundColor = lib.mkOption {
      type = lib.types.str;
      default = "green";
      description = "Background color for the tmux status bar on server profiles.";
    };
  };

  config.programs.tmux = {
    shortcut = "b";

    extraConfig = ''
      set -g status-style "bg=${cfg.statusBarBackgroundColor}"
    '';
  };
}
