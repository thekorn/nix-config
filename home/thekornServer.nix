{pkgs, ...}: {
  imports = [
    ./shared/programs/bat.nix
    ./shared/programs/eza.nix
    ./shared/programs/fzf.nix
    ./shared/programs/git.nix
    ./shared/programs/tmux.server.nix
    ./shared/programs/zsh.server.nix
    ./shared/devel.nix
    ./shared/programs/nvim.nix
    ./shared/programs/lazygit.nix
    ./shared/programs/ripgrep.nix
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
    awscli2
    silver-searcher
    jq
    htop
    delta
    httpie
    alejandra
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

  services.ssh-agent.enable = true;
  programs.ssh.addKeysToAgent = "yes";
}
