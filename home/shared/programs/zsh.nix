{config, ...}: {
  imports = [./zsh.common.nix];

  programs.zsh = {
    shellAliases = {
      sim = "open -a Simulator";
    };

    sessionVariables = {
      TMUX_SESSIONIZER_EXTRA_DIRS = "/tmp ${config.home.homeDirectory}/.config/nix ${config.home.homeDirectory}/.config/nvim";
    };

    siteFunctions = {
      updateNvim = ''
        setopt localoptions
        local CONFIG_DIR=~/.config/nvim
        [ -d "$CONFIG_DIR/.git" ] || git clone -b main git@github.com:thekorn/config.nvim.git $CONFIG_DIR
        pushd $CONFIG_DIR >/dev/null || return
        {
          git checkout main
          git pull
        } always {
          popd >/dev/null
        }
      '';
      nixswitch = ''
        sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/.config/nix
      '';
      update = ''
        setopt localoptions errreturn
        pushd ~/.config/nix >/dev/null || return
        {
          git pull
          nix flake update --commit-lock-file
          git pu
        } always {
          popd >/dev/null
        }
        nixswitch
        updateBrew
        updateNvim
      '';
      updateBrew = ''
        setopt localoptions errreturn
        brew update
        brew upgrade --greedy
      '';
    };
  };
}
