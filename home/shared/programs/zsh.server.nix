{
  pkgs,
  config,
  ...
}: {
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
    };
    zprof = {
      enable = false;
    };
    initExtra = ''
      source ${pkgs.zsh-forgit}/share/zsh/zsh-forgit/forgit.plugin.zsh
      eval "$(fnm env --use-on-cd --version-file-strategy recursive)"

      zstyle :omz:plugins:ssh-agent identities id_ed25519
    '';
    localVariables = {
      ZSH_TMUX_AUTOSTART = "true";
      ZSH_TMUX_AUTOSTART_ONCE = "true";
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
      custom = "$HOME/.zsh_custom";
      plugins = ["git" "tmux" "fzf" "fnm" "ssh-agent"];
    };
  };
  home.file.".zsh_custom/functions.zsh".source = ./dotfiles/zsh_custom/functions.server.zsh;
}
