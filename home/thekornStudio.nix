{ pkgs, ... }: {

  imports = [
    ./shared/1password.nix
    ./shared/alacritty.nix
    ./shared/bat.nix
    ./shared/eza.nix
    ./shared/fzf.nix
    ./shared/git.nix
    ./shared/tmux.nix
    ./shared/zsh.nix
    ./shared/ssh.nix
    ./shared/devel.nix
    ./shared/nvim.nix
    ./shared/bottom.nix
    ./shared/lazygit.nix
    ./shared/ripgrep.nix
    ./shared/opencommit.nix
    ./shared/openinterpreter.nix
    ./shared/nushell.nix
    ./shared/atuin.nix
    ./shared/zed.nix
    ./shared/android-studio.nix
    #./shared/zig.nix <- zig 0.12 is still unstable in nix, using zig from brew
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";
  # specify my home-manager configs
  home.packages = with pkgs; [
    fd
    curl
    less
    zsh-forgit
    fnm
    awscli
    silver-searcher
    jq
    htop
    delta
    rustup
    httpie
    mkcert
    mongosh
    go
    nixfmt
    ffmpeg
    nodePackages.pnpm
    wget
  ];
  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nano";

    JIRA_URL = "https://burdaforward.atlassian.net";
    JIRA_NAME = "markus.korn";
    JIRA_DEFAULT_ACTION = "new";

    # pnpm
    PNPM_HOME = "$HOME/.local/share/pnpm";

    #bunte monorepo
    BROWSERSLIST_IGNORE_OLD_DATA = 1;

  };

  home.sessionPath = [
    "$PNPM_HOME"
    "$HOME/.pub-cache/bin"

    "$HOME/.local/bin"
    "$HOME/.gpkg/bin"
  ];
}
