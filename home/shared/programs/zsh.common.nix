{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./eza.nix
    ./lazygit.nix
    ./nvim.nix
    ./zsh-plugins.nix
  ];
  home.packages = with pkgs; [fnm curl];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    completionInit = lib.mkAfter ''
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
    '';
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
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_MINUS

      eval "$(fnm env --use-on-cd --version-file-strategy recursive)"
      if [[ -n "$ZSH_FNM_NODE_VERSION" && "$(fnm default)" != "v${ZSH_FNM_NODE_VERSION}" ]]; then
        fnm default "$ZSH_FNM_NODE_VERSION"
      fi
    '';

    sessionVariables = {
      # CTF
      APH = "Pragma: akamai-x-get-cache-tags, akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no, akamai-x-get-request-id, akamai-x-request-trace, akamai-x--meta-trace, akama-xi-get-extracted-values";

      # fnm
      ZSH_FNM_NODE_VERSION = "24.18.0";
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

    siteFunctions = {
      mkcd = ''
        mkdir --parents "$1" && cd "$1"
      '';
      ccd = ''
        setopt localoptions errreturn

        if (( $# != 1 )); then
          echo "usage: ccd <git-remote-url>" >&2
          return 1
        fi

        local url="$1"
        local host repo_path target

        if [[ "$url" =~ '^https?://([^/]+)/(.+)$' ]]; then
          host="$match[1]"
          repo_path="$match[2]"
        elif [[ "$url" =~ '^git@([^:]+):(.+)$' ]]; then
          host="$match[1]"
          repo_path="$match[2]"
        elif [[ "$url" =~ '^ssh://git@([^/]+)/(.+)$' ]]; then
          host="$match[1]"
          repo_path="$match[2]"
        elif [[ "$url" =~ '^git://([^/]+)/(.+)$' ]]; then
          host="$match[1]"
          repo_path="$match[2]"
        else
          echo "ccd: unsupported git remote url: $url" >&2
          return 1
        fi

        repo_path="''${repo_path%.git}"
        repo_path="''${repo_path%/}"

        target="$HOME/devel/$host/$repo_path"

        if [[ -d "$target" ]]; then
          cd "$target"
          return 0
        fi

        mkdir -p "''${target:h}"
        git clone "$url" "$target"
        cd "$target"
      '';
    };
  };
}
