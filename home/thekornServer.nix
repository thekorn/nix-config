{pkgs, ...}: {
  imports = [
    ./shared/programs/bat.nix
    ./shared/programs/eza.nix
    ./shared/programs/fzf.nix
    ./shared/programs/git.nix
    ./shared/programs/tmux.nix
    ./shared/programs/zsh.nix
    #./shared/programs/ssh.nix
    ./shared/devel.nix
    ./shared/programs/nvim.nix
    #./shared/programs/bottom.nix
    ./shared/programs/lazygit.nix
    ./shared/programs/ripgrep.nix
    #./shared/programs/opencommit.nix
    #./shared/programs/nushell.nix
    #./shared/programs/hyprland.nix
    #./shared/programs/android-studio.nix
    #./shared/programs/pnpm.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
  # specify my home-manager configs
  home.packages = with pkgs; [
    fd
    curl
    less
    zsh-forgit
    fnm
    #nodejs_20
    awscli2
    silver-searcher
    jq
    htop
    delta
    #rustup
    httpie
    #mkcert
    #mongosh
    #go
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
  ];
}
