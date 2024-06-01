{pkgs, ...}: {
  imports = [
    #./shared/alacritty.nix
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
    ./shared/nushell.nix
    ./shared/android-studio.nix
    ./shared/pnpm.nix
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
    nodejs_20
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
    alejandra
    ffmpeg
    unzip
  ];
  home.sessionVariables = {
    PAGER = "less";
    CLICLOLOR = 1;
    EDITOR = "nano";
  };

  home.sessionPath = [
    "$HOME/.pub-cache/bin"

    "$HOME/.local/bin"
    "$HOME/.gpkg/bin"
  ];
}
