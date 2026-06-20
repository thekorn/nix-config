{
  pkgs,
  lib,
  ...
}: let
  pluginPath = lib.makeBinPath [pkgs.tmux pkgs.bash pkgs.coreutils] + ":/usr/bin:/bin";
in {
  imports = [./tmux.common.nix];

  programs.tmux = {
    shortcut = "a";

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.nord;
        extraConfig = ''
          set-environment -g PATH "${pluginPath}"
        '';
      }
    ];

    extraConfig = ''
      set -g status-right "#{prefix_highlight}#[fg=brightblack,bg=black,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %Y-%m-%d #[fg=white,bg=brightblack,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %H:%M #[fg=cyan,bg=brightblack,nobold,noitalics,nounderscore]#[fg=black,bg=cyan,bold] #h "

      bind C-d display-popup -h 30 -w 100 -E "workmux dashboard"
      bind C-s run-shell "workmux sidebar"
    '';
  };
}
