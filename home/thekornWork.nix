{pkgs, ...}: {
  imports = [
    ./shared/programs/1password.nix
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
    ./shared/programs/atuin.nix
    ./shared/programs/opencommit.nix
    ./shared/programs/openinterpreter.nix
    ./shared/programs/android-studio.nix
    ./shared/programs/work.nix
    ./shared/programs/pnpm.nix
    ./shared/programs/zed.nix
    ./shared/programs/zig.nix
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
    alejandra
    ffmpeg
    lcov
    wget
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
