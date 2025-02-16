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
}
