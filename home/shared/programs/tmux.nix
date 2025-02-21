{
  pkgs,
  config,
  ...
}: let
  sessionizer = pkgs.writeShellScriptBin "tmux-sessionizer" ''
    ## from https://github.com/mrnugget/dotfiles/blob/master/bin/tmux-sessionizer

    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        specific_directories=("/tmp" "~/.config/nix" "~/.config/nvim")
        combined_directories=($(${pkgs.fd}/bin/fd -p -t d -d 3 --min-depth 3 . ~/devel/ | sed "s;$HOME;~;") "''${specific_directories[@]}")
        selected=$(printf '%s\n' "''${combined_directories[@]}" | ${pkgs.fzf}/bin/fzf)
    fi

    if [[ -z $selected ]]; then
        exit 0
    fi

    selected=$(echo $selected | sed "s;~;$HOME;")

    selected_name=$(basename "$selected" | tr . _)
    tmux_running=$(pgrep tmux)
    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        ${pkgs.tmux}/bin/tmux new-session -s $selected_name -c $selected
        exit 0
    fi

    if ! ${pkgs.tmux}/bin/tmux has-session -t $selected_name 2>/dev/null; then
        ${pkgs.tmux}/bin/tmux new-session -ds $selected_name -c $selected
    fi

    if [[ -z $TMUX ]]; then
        ${pkgs.tmux}/bin/tmux attach-session -t $selected_name
    else
        ${pkgs.tmux}/bin/tmux switch-client -t $selected_name
    fi
  '';
in {
  programs.tmux = {
    enable = true;
    historyLimit = 5000;
    shortcut = "a";
    secureSocket = false;
    terminal = "screen-256color";
    newSession = true;

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

      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "~/.config/tmux/tmux.conf reloaded"

      bind Enter copy-mode # enter copy mode

      set-option -g detach-on-destroy off       # dont quit the terminal session if there is at least one other tmux session running
      set -g status-left-length 32              # we have more space on the session name field

      set -g status-right "#{prefix_highlight}#[fg=brightblack,bg=black,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %Y-%m-%d #[fg=white,bg=brightblack,nobold,noitalics,nounderscore]#[fg=white,bg=brightblack] %H:%M #[fg=cyan,bg=brightblack,nobold,noitalics,nounderscore]#[fg=black,bg=cyan,bold] #h "

      bind-key S run-shell "tmux popup -E ${sessionizer}/bin/tmux-sessionizer"
      bind-key N run-shell "${sessionizer}/bin/tmux-sessionizer ~/.config/nix"
    '';
  };
}
