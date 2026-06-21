{
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    autocd = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # eza vs ls
      ls = "eza";
      ll = "eza --long --header --git --icons";
      tree = "ll --tree --level=4 -a -I=.git --git-ignore";

      # git
      ## Goes up the tree to the git root dir
      "g-" = ''cd $(git rev-parse --show-toplevel || echo ".")'';
      "cm" = "git cm"; #alternativvely use "ocm" for opencommit
      "cma" = "git add . && cm";
      "cmap" = "cma && git push";

      # lazygit
      lg = "lazygit";

      ## git
      cbr = ''git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff --color=always {1}" --pointer="" | xargs git checkout'';

      ## neovim
      vi = "nvim";
      vim = "nvim";

      ## CTF
      akacurl = "curl -H '$APH' -H 'bf-debug: true'";
      akastgcurl = "curl -H '$APH' -H 'bf-debug: true' --resolve '*:443:23.50.55.49'";
    };

    zprof.enable = false;

    initContent = lib.mkAfter ''
      source ${pkgs.zsh-forgit}/share/zsh/zsh-forgit/forgit.plugin.zsh
      eval "$(fnm env --use-on-cd --version-file-strategy recursive)"
    '';

    sessionVariables = {
      ## CTF
      APH = "Pragma: akamai-x-get-cache-tags, akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no, akamai-x-get-request-id, akamai-x-request-trace, akamai-x--meta-trace, akama-xi-get-extracted-values";
    };

    dirHashes = {
      nix = "$HOME/.config/nix";
      devel = "$HOME/devel";
      github = "$HOME/devel/github.com";
      bitbucket = "$HOME/devel/bitbucket.org";
      thekorn = "$HOME/devel/github.com/thekorn";
      burdastudios = "$HOME/devel/bitbucket.org/burdastudios";
      bfops = "$HOME/devel/gitlab.bfops.io";
    };

    oh-my-zsh.enable = false;
    zplug = {
      enable = true;
      plugins = [
        {name = "gerges-zz/oh-my-zsh-jira-plus";}
        {name = "ltj/gitgo";}
      ];
    };
  };
}
