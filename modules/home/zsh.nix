{ pkgs, config, ... }:
{

  programs.ssh.enable = true;

  programs.zsh = {

    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    shellAliases = {
      # nix
      nixswitch = "darwin-rebuild switch --flake ~/.config/nix/.#";
      update = "pushd ~/.config/nix; git pull; nix flake update; nixswitch; popd";

      ## android studio
      "android-studio" = "open -a /Applications/Android\\ Studio.app";


      # bunte
      # bunte = "wo bunte";

      # helper
      #tms = "tmux-sessionizer";
      #npm-check-updates = "npx npm-check-updates -u";

      # vs code
      ca = "code -a";

      # exa vs ls
      ls = "exa";
      ll = "exa --long --header --git --icons";
      tree = "ll --tree --level=4 -a -I=.git --git-ignore";

      # local rush for testing
      #testrush = "node ~/devel/github.com/thekorn/rushstack/libraries/rush-lib/lib/start.js";
      #testrushx = "node ~/devel/github.com/thekorn/rushstack/libraries/rush-lib/lib/startx.js";

      # Goes up the tree to the git root dir
      "g-" = "cd $(git rev-parse --show-toplevel || echo \".\")";

      # lazygit
      lg = "lazygit";

      ## firefox
      ff = "firefox --new-tab";
      ffs = "firefox --search";
      ffp = "firefox --private-window";

      ## snowflake
      snowsql = "/Applications/SnowSQL.app/Contents/MacOS/snowsql";

      ## git 
      cbr = "git branch --sort=-committerdate | fzf --header \"Checkout Recent Branch\" --preview \"git diff {1} --color=always\" --pointer=\"\" | xargs git checkout";
    };
    initExtra = ''
      source ${pkgs.zsh-forgit}/share/zsh/zsh-forgit/forgit.plugin.zsh
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      eval "$(fnm env --use-on-cd)"
    '';
    localVariables = {
      ZSH_TMUX_AUTOSTART = "true";
      ZSH_TMUX_AUTOSTART_ONCE = "true";
    };
    dirHashes = {
      devel = "$HOME/devel";
      github = "$HOME/devel/github.com";
      bitbucket = "$HOME/devel/bitbucket.org";
      thekorn = "$HOME/devel/github.com/thekorn";
      burdastudios = "$HOME/devel/bitbucket.org/burdastudios";
      bfops = "$HOME/devel/gitlab.bfops.io";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "ssh-agent" "tmux" "jira" "aws" "z" "web-search" "fzf" "flutter" "fnm" ];
      extraConfig = ''
        zstyle :omz:plugins:ssh-agent lifetime 4h
        zstyle :omz:plugins:ssh-agent agent-forwarding on
        # zstyle :omz:plugins:ssh-agent identities keys/id_rsa keys/id_rsa.bitbucket.burdastudios keys/id_ed25519.gitlab.bfops.io
      '';
      custom = "$HOME/.zsh_custom";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };

  home.file.".p10k.zsh".source = ./dotfiles/.p10k.zsh;
  home.file.".zsh_custom/functions.zsh".source = ./dotfiles/zsh_custom/functions.zsh;
}