{
  config,
  pkgs,
  lib,
  ...
}: let
  minimalTmuxStatus = pkgs.tmuxPlugins.minimal-tmux-status;
  sshTmuxConfig = pkgs.writeText "tmux-ssh.conf" ''
    source-file "${config.home.homeDirectory}/.config/tmux/tmux.conf"

    unbind C-a
    set -g prefix C-b
    bind C-b send-prefix

    set -g @minimal-tmux-fg "#2E3440"
    set -g @minimal-tmux-bg "#D08770"
    set -g @minimal-tmux-status-right-extra " (SSH #h)"
    run-shell ${minimalTmuxStatus.rtp}
  '';
in {
  imports = [
    ./zsh.common.nix
    ./oh-my-posh.nix
  ];

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
