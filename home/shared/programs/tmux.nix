{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.tmux;
in {
  options.custom.tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkIf (cfg.enable && !cfg.server.enable) {
    programs.zsh = {
      sessionVariables = {
        TMUX_SESSIONIZER_EXTRA_DIRS = "/tmp ${config.home.homeDirectory}/.config/nix";
      };
    };

    programs.tmux = {
      shortcut = "a";

      plugins = with pkgs; [tmuxPlugins.nord];

      extraConfig = ''
        set -g status-right "#{prefix_highlight}#[fg=brightblack,bg=black,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %Y-%m-%d #[fg=white,bg=brightblack,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %H:%M #[fg=cyan,bg=brightblack,nobold,noitalics,nounderscore]#[fg=black,bg=cyan,bold] #h "
        set -g status-left-length 32              # we have more space on the session name field

        # workmux
        #bind C-d display-popup -h 30 -w 100 -E "workmux dashboard"
        #bind C-s run-shell "workmux sidebar"
      '';
    };
  };
}
