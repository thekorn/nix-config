{ pkgs, gpkg, lazyvim, ... }: {
  # Don't change this when you change package input. Leave it alone.
  home.stateVersion = "22.11";
  # specify my home-manager configs
  home.packages = with pkgs; [
    ripgrep
    fd
    curl
    less
    zsh-forgit
    fnm
    nodejs
    awscli
    silver-searcher
    teams
    jq
    htop
    lazygit
    vscode
    delta
    rustup
    httpie
    mkcert
    mongosh
    go
    bottom
    cocoapods
    neovim

    gpkg
    #nodePackages.pnpm
  ];
  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nano";

    JIRA_URL = "https://burda-studios.atlassian.net";
    JIRA_NAME = "markus.korn";
    JIRA_DEFAULT_ACTION= "new";

    ANDROID_HOME = "$HOME/Library/Android/sdk";
    LG_CONFIG_FILE = "$HOME/.config/lazygit/config.yml";

    # pnpm
    PNPM_HOME = "$HOME/.local/share/pnpm";

  };

  home.sessionPath = [
    "$HOME/.gpkg/bin"
    
    "$ANDROID_HOME/emulator"
    "$ANDROID_HOME/cmdline-tools/latest/bin"
    "$ANDROID_HOME/tools"
    "$ANDROID_HOME/tools/bin"
    "$ANDROID_HOME/platform-tools"

    "$PNPM_HOME:$PATH"
  ];

  home.file = {
    ".config/lazygit/config.yml".source = ../home/dotfiles/lazygit.yml;
    ".ripgreprc".source = ../home/dotfiles/.ripgreprc;
    ".config/bottom/bottom.toml".source = ../home/dotfiles/bottom/bottom.toml;
    ".config/nvim".source = lazyvim;
  };
}
