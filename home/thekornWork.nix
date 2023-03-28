{ pkgs, lazyvim, ... }: {

  imports = [
    ./shared/alacritty.nix
    ./shared/bat.nix
    ./shared/exa.nix
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
    #teams
    jq
    htop
    vscode
    delta
    rustup
    httpie
    mkcert
    mongosh
    go
    cocoapods
    nixfmt
    ffmpeg
    lcov
    nodePackages.pnpm
  ];
  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nano";

    JIRA_URL = "https://burda-studios.atlassian.net";
    JIRA_NAME = "markus.korn";
    JIRA_DEFAULT_ACTION = "new";

    ANDROID_HOME = "$HOME/Library/Android/sdk";
    LG_CONFIG_FILE = "$HOME/.config/lazygit/config.yml";

    # pnpm
    PNPM_HOME = "$HOME/.local/share/pnpm";

  };

  home.sessionPath = [
    "$ANDROID_HOME/emulator"
    "$ANDROID_HOME/cmdline-tools/latest/bin"
    "$ANDROID_HOME/tools"
    "$ANDROID_HOME/tools/bin"
    "$ANDROID_HOME/platform-tools"

    "$PNPM_HOME:$PATH"
  ];
}
