{
  config,
  pkgs,
  lib,
  ...
}: let
  sshTmuxConfig = pkgs.writeText "tmux-ssh.conf" ''
    source-file "${config.home.homeDirectory}/.config/tmux/tmux.conf"

    set -g status-style "bg=#BF616A,fg=#2E3440"
    set -g status-left "#[fg=#2E3440,bg=#BF616A,bold] SSH #S "
    set -g status-right "#[fg=#2E3440,bg=#BF616A,bold] #h | %Y-%m-%d %H:%M "
    set -g window-status-current-style "bg=#BF616A,fg=#2E3440,bold"
  '';
in {
  imports = [./zsh.common.nix];

  programs.oh-my-posh.enableZshIntegration = false;

  programs.zsh = {
    shellAliases = {
      sim = "open -a Simulator";
    };

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        if [[ -n "$SSH_CONNECTION" && -z "$TMUX" && "$TERM" != "dumb" ]] && [[ -t 0 && -t 1 ]]; then
          exec ${pkgs.tmux}/bin/tmux -L ssh -f ${sshTmuxConfig} new-session -A -s default
        fi
      '')
      (lib.mkAfter ''
        if [[ -n "$SSH_CONNECTION" ]]; then
          eval "$(${lib.getExe config.programs.oh-my-posh.package} init zsh --config ${./dotfiles/oh-my-posh/material.omp.json})"
        else
          eval "$(${lib.getExe config.programs.oh-my-posh.package} init zsh --config ${config.xdg.configHome}/oh-my-posh/config.json)"
        fi
      '')
    ];

    siteFunctions = {
      nixswitch = ''
        sudo -H nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/.config/nix
      '';
      update-server = ''
        local host failed=0

        for host in thekorn-vm thekorn-vm-desktop thekorn-server thekorn-server-2; do
          echo "Deploying $host..."
          if ! nix run ~/.config/nix#deploy-$host; then
            echo "update-server: failed to deploy $host" >&2
            failed=1
          fi
        done

        return $failed
      '';
      update = ''
        setopt localoptions errreturn
        unsetopt auto_pushd
        local oldpwd=$PWD
        cd ~/.config/nix || return
        {
          git pull
          nix flake update --commit-lock-file
          git pu
        } always {
          cd "$oldpwd"
        }
        nixswitch
        updateBrew
      '';
      updateBrew = ''
        setopt localoptions errreturn
        brew update
        brew upgrade --greedy --yes
      '';
    };
  };
}
