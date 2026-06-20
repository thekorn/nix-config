{
  pkgs,
  config,
  lib,
  ...
}: let
  pluginPath = lib.makeBinPath [pkgs.tmux pkgs.bash pkgs.coreutils] + ":/usr/bin:/bin";
in {
  programs.tmux = {
    enable = true;
    historyLimit = 5000;
    shortcut = "a";
    secureSocket = false;
    terminal = "screen-256color";
    newSession = false;

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.nord;
        extraConfig = ''
          set-environment -g PATH "${pluginPath}"
        '';
      }
      tmuxPlugins.pain-control
    ];

    extraConfig = ''
      set -g default-terminal "screen-256color" # colors!
      set -as terminal-features ",xterm-256color:RGB"
      setw -g xterm-keys on
      set -s escape-time 10                     # faster command sequences
      set -sg repeat-time 600                   # increase repeat timeout
      set -s focus-events on

      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "~/.config/tmux/tmux.conf reloaded"

      bind Enter copy-mode # enter copy mode

      set-option -g detach-on-destroy off       # dont quit the terminal session if there is at least one other tmux session running
      set -g status-left-length 32              # we have more space on the session name field

      set -g status-right "#{prefix_highlight}#[fg=brightblack,bg=black,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %Y-%m-%d #[fg=white,bg=brightblack,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %H:%M #[fg=cyan,bg=brightblack,nobold,noitalics,nounderscore]#[fg=black,bg=cyan,bold] #h "

      bind-key N run-shell "zsh -i -c 'ts $1' _ ~/.config/nix"

      bind C-d display-popup -h 30 -w 100 -E "workmux dashboard"
      bind C-s run-shell "workmux sidebar"
    '';
  };
}
