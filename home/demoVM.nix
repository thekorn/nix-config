{pkgs, ...}: {
  imports = [
    ./shared/programs/alacritty.nix
    ./shared/programs/bat.nix
    ./shared/programs/eza.nix
    ./shared/programs/fzf.nix
    ./shared/programs/git.nix
    ./shared/programs/tmux.nix
    ./shared/programs/zsh.nix
    ./shared/programs/ssh.nix
    ./shared/devel.nix
    ./shared/programs/nvim.nix
    ./shared/programs/bottom.nix
    ./shared/programs/lazygit.nix
    ./shared/programs/ripgrep.nix
    ./shared/programs/android-studio.nix
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
    awscli2
    silver-searcher
    jq
    htop
    vscode
    delta
    rustup
    httpie
    mkcert
    mongosh
    go
    alejandra
    ffmpeg
    nodePackages.pnpm
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
  };

  home.sessionPath = ["$PNPM_HOME"];
}
