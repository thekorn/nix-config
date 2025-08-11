{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };
    shellAliases = {
      # helper
      #npm-check-updates = "npx npm-check-updates -u";

      # vs code
      c = "code";
      ca = "code -a";

      # eza vs ls
      ls = "eza";
      ll = "eza --long --header --git --icons";
      tree = "ll --tree --level=4 -a -I=.git --git-ignore";

      # local rush for testing
      #testrush = "node ~/devel/github.com/thekorn/rushstack/libraries/rush-lib/lib/start.js";
      #testrushx = "node ~/devel/github.com/thekorn/rushstack/libraries/rush-lib/lib/startx.js";

      # git
      ## Goes up the tree to the git root dir
      "g-" = ''cd $(git rev-parse --show-toplevel || echo ".")'';
      "cm" = "git cm"; #alternativvely use "ocm" for opencommit
      "cma" = "git add . && cm";
      "cmap" = "cma && git push";

      # lazygit
      lg = "lazygit";

      ## firefox
      ff = "${pkgs.firefox-bin-unwrapped}/Applications/Firefox.app/Contents/MacOS/firefox --new-tab";
      ffs = "${pkgs.firefox-bin-unwrapped}/Applications/Firefox.app/Contents/MacOS/firefox --search";
      ffp = "${pkgs.firefox-bin-unwrapped}/Applications/Firefox.app/Contents/MacOS/firefox --private-window";

      ## git
      cbr = ''git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff --color=always {1}" --pointer="" | xargs git checkout'';

      sim = "open -a Simulator";

      ## rush
      rxb = "rushx build";
      rxbt = "rushx _phase:build && rushx _phase:test";

      ## neovim
      vi = "nvim";
      vim = "nvim";

      ## CTF
      akacurl = "curl -H '$APH' -H 'bf-debug: true'";
      akastgcurl = "curl -H '$APH' -H 'bf-debug: true' --resolve '*:443:23.50.55.49'";
    };
    zprof = {
      enable = false;
    };
    initContent = ''
      source ${pkgs.zsh-forgit}/share/zsh/zsh-forgit/forgit.plugin.zsh
      eval "$(fnm env --use-on-cd --version-file-strategy recursive)"
    '';
    localVariables = {
      ZSH_TMUX_AUTOSTART = "true";
      ZSH_TMUX_AUTOSTART_ONCE = "true";
      ZSH_WEB_SEARCH_ENGINES = [
        "tt"
        "https://burdaforward.atlassian.net/jira/software/c/projects/TT/boards/611/backlog?text="
      ];
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
    oh-my-zsh = {
      enable = true;
      #plugins =
      #  [ "git" "tmux" "jira" "aws" "z" "web-search" "fzf" "flutter" "fnm" ];
      custom = "$HOME/.zsh_custom";
      extraConfig = ''
        plugins=(git tmux jira aws z web-search fzf fnm)
        if [ "$DISABLE_TMUX" = "1" ]
        then
          plugins[$plugins[(i)tmux]]=()
        fi
      '';
    };
  };
  home.file.".zsh_custom/functions.zsh".source = ./dotfiles/zsh_custom/functions.zsh;
}
