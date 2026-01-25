{pkgs, ...}: {
  imports = [
    ./programs/bat.nix
    ./programs/eza.nix
    ./programs/fzf.nix
    ./programs/git.server.nix
    ./programs/tmux.server.nix
    ./devel.nix
    ./programs/nvim.nix
    ./programs/lazygit.nix
    ./programs/ripgrep.nix
    ./programs/zig.nix
  ];
}
