{pkgs, ...}: let
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
  imports = [./tmux.common.nix];

  programs.tmux = {
    shortcut = "b";

    extraConfig = ''
      bind-key S run-shell "tmux popup -E ${sessionizer}/bin/tmux-sessionizer"
      bind-key N run-shell "${sessionizer}/bin/tmux-sessionizer ~/.config/nix"
    '';
  };
}
