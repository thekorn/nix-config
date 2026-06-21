{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    sessionVariables = {
      TMUX_SESSIONIZER_DIRS = "${config.home.homeDirectory}/devel";
      TMUX_SESSIONIZER_DEPTH = 3;
      TMUX_SESSIONIZER_BIND = "S";
    };

    zplug = {
      enable = true;
      plugins = [
        {name = "thekorn/tmux-sessionizer";}
      ];
    };
  };
  programs.tmux = {
    enable = true;
    historyLimit = 5000;
    secureSocket = false;
    terminal = "screen-256color";
    newSession = false;

    plugins = with pkgs; [tmuxPlugins.pain-control];

    extraConfig = ''
      set -g default-terminal "screen-256color" # colors!
      set -as terminal-features ",xterm-256color:RGB"
      setw -g xterm-keys on
      set -s escape-time 10                     # faster command sequences
      set -sg repeat-time 600                   # increase repeat timeout
      set -s focus-events on

      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "~/.config/tmux/tmux.conf reloaded"
      bind-key N run-shell "zsh -i -c 'ts $1' _ ~/.config/nix"

      bind Enter copy-mode # enter copy mode

      set-option -g detach-on-destroy off       # dont quit the terminal session if there is at least one other tmux session running
    '';
  };
}
