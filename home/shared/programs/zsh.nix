{
  imports = [./zsh.common.nix];

  programs.zsh = {
    shellAliases = {
      sim = "open -a Simulator";
    };

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
        brew upgrade --greedy
      '';
    };
  };
}
