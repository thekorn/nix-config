{
  pkgs,
  lib,
  config,
  ...
}: {
  config.programs.zsh = lib.mkIf (config.custom.zsh.enable && config.custom.zsh.server) {
    initContent = lib.mkBefore ''
      if [[ -n "$SSH_CONNECTION" && -z "$TMUX" && "$TERM" != "dumb" ]] && [[ -t 0 && -t 1 ]]; then
        exec ${pkgs.tmux}/bin/tmux new-session -A -s default
      fi
    '';
  };
}
