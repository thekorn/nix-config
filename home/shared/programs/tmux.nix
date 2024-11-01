{
  pkgs,
  config,
  ...
}: {
  home.file.".local/bin/tmux-sessionizer".source = ./bin/tmux-sessionizer;
  home.file.".local/bin/api".source = ./bin/api;
  programs.tmux = {
    enable = true;
    historyLimit = 5000;
    shortcut = "a";
    secureSocket = false;
    terminal = "screen-256color";
    newSession = true;
    # use tmux 3.4 as 3.5a always starts /bin/sh in nixpkgs-unstable
    package = pkgs.callPackage ./vendor/tmux34.nix {};

    plugins = with pkgs; [tmuxPlugins.nord tmuxPlugins.pain-control];

    extraConfig = ''
      set -g default-terminal "screen-256color" # colors!
      set -as terminal-features ",xterm-256color:RGB"
      setw -g xterm-keys on
      set -s escape-time 10                     # faster command sequences
      set -sg repeat-time 600                   # increase repeat timeout
      set -s focus-events on

      set -g prefix2 C-a                        # GNU-Screen compatible prefix
      bind C-a send-prefix -2

      set -q -g status-utf8 on                  # expect UTF-8 (tmux < 2.2)
      setw -q -g utf8 on

      set -g history-limit 5000                 # boost history

      bind-key r source-file ~/.conf/tmux/tmux.conf \; display-message "~/.conf/tmux/tmux.conf reloaded"

      bind Enter copy-mode # enter copy mode

      set-option -g detach-on-destroy off       # dont quit the terminal session if there is at least one other tmux session running
      set -g status-left-length 32              # we have more space on the session name field

      set -g status-right "#{prefix_highlight}#[fg=brightblack,bg=black,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %Y-%m-%d #[fg=white,bg=brightblack,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %H:%M #[fg=cyan,bg=brightblack,nobold,noitalics,nounderscore]#[fg=black,bg=cyan,bold] #h "

      bind-key S run-shell "tmux popup -E ~/.local/bin/tmux-sessionizer"
      bind-key N run-shell "~/.local/bin/tmux-sessionizer ~/.config/nix"
    '';
  };
}
