{ pkgs, config, ... }: {
  programs.zsh = {

    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting = { enable = true; };
    shellAliases = {

      ## android studio
      "android-studio" = "open -a /Applications/Android\\ Studio.app";

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
      "cma" = "git add . && cm";

      # lazygit
      lg = "lazygit";

      ## firefox
      ff = "firefox --new-tab";
      ffs = "firefox --search";
      ffp = "firefox --private-window";

      ## snowflake
      snowsql = "/Applications/SnowSQL.app/Contents/MacOS/snowsql";

      ## git
      cbr = ''
        git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff --color=always {1}" --pointer="" | xargs git checkout'';

      sim = "open -a Simulator";

      ## open interpreter
      interpreter = ''
        op run --env-file="$HOME/.config/openinterpreter.env" -- interpreter'';
    };
    zprof = { enable = false; };
    initExtra = ''
      source ${pkgs.zsh-forgit}/share/zsh/zsh-forgit/forgit.plugin.zsh
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      eval "$(fnm env --use-on-cd --version-file-strategy recursive)"
    '';
    localVariables = {
      ZSH_TMUX_AUTOSTART = "true";
      ZSH_TMUX_AUTOSTART_ONCE = "true";
      ZSH_WEB_SEARCH_ENGINES = [
        "tt"
        "https://burdaforward.atlassian.net/jira/software/c/projects/TT/boards/611/backlog?text="
      ];
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
      extraConfig   = ''
        plugins=(git tmux jira aws z web-search fzf flutter fnm)
        if [ "$DISABLE_TMUX" = "1" ]
        then
          plugins[$plugins[(i)tmux]]=()
        fi
      '';
    };
    plugins = [{
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }];
  };

  home.file.".p10k.zsh".source = ./dotfiles/.p10k.zsh;
  home.file.".zsh_custom/functions.zsh".source =
    ./dotfiles/zsh_custom/functions.zsh;
}
