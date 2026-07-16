{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./zsh.common.nix
    ./tmux.server.nix
    ./oh-my-posh.server.nix
  ];

  programs.zsh = {
    initContent = lib.mkBefore ''
      if [[ -n "$SSH_CONNECTION" && -z "$TMUX" && "$TERM" != "dumb" ]] && [[ -t 0 && -t 1 ]]; then
        exec ${pkgs.tmux}/bin/tmux new-session -A -s default
      fi
    '';
  };
}
