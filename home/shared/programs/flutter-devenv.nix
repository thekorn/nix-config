{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  options.custom.flutterDevenv.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Provide an on-demand, global Flutter devenv and Zsh shortcut.";
  };

  config = lib.mkIf config.custom.flutterDevenv.enable {
    home.packages = [pkgs.devenv];

    xdg.configFile = {
      "devenvs/flutter/devenv.nix".source = ./dotfiles/devenvs/flutter.nix;
      "devenvs/flutter/devenv.yaml".text = ''
        inputs:
          nixpkgs:
            url: github:NixOS/nixpkgs/${inputs.nixpkgs.rev}
        allowUnfree: true
        prompt_prefix: false
      '';
    };

    programs.zsh.siteFunctions = lib.mkIf config.custom.zsh.enable {
      dv-flutter = ''
        (
          local project_dir="$PWD"
          local state_dir=${lib.escapeShellArg "${config.xdg.stateHome}/devenvs/flutter"}
          command mkdir -p -- "$state_dir" || return
          builtin cd -q -- "$state_dir" || return

          ${lib.getExe pkgs.devenv} --from ${lib.escapeShellArg "path:${config.xdg.configHome}/devenvs/flutter"} --shell zsh shell ${lib.getExe pkgs.zsh} -fc '
            builtin cd -q -- "$1" || exit
            shift
            if (( $# )); then
              exec "$@"
            else
              exec ${lib.getExe pkgs.zsh} -i
            fi
          ' dv-flutter "$project_dir" "$@"
        )
      '';
    };
  };
}
