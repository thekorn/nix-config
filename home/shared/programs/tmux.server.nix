{
  config,
  pkgs,
  lib,
  osConfig ? {},
  ...
}: let
  cfg = config.custom.tmux.server;

  configuredHostName = lib.attrByPath ["networking" "hostName"] null osConfig;
  extraHostname =
    if configuredHostName != null && configuredHostName != ""
    then configuredHostName
    else "default";
in {
  options.custom.tmux.server = {
    enable = lib.mkEnableOption "the server tmux variant";
    statusBarBackgroundColor = lib.mkOption {
      type = lib.types.str;

      # green: #A3BE8C
      # red: #BF616A
      # blue: #5E81AC
      default = "#A3BE8C";

      description = "Background color for the tmux status bar on server profiles.";
    };
  };

  config = lib.mkIf (config.custom.tmux.enable && cfg.enable) {
    programs.zsh = {
      sessionVariables = {
        TMUX_SESSIONIZER_EXTRA_DIRS = "/tmp";
      };
    };

    programs.tmux = {
      shortcut = "b";

      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.minimal-tmux-status; # as now available in nixpkgs
          extraConfig = ''
            set -g @minimal-tmux-fg "#2E3440"
            set -g @minimal-tmux-bg "${cfg.statusBarBackgroundColor}"
            set -g @minimal-tmux-status-right-extra " (${lib.escapeShellArg extraHostname})"
          '';
        }
      ];
    };
  };
}
