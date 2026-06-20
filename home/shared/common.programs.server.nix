{pkgs, ...}: {
  imports = [
    ./programs/bat.nix
    ./programs/eza.nix
    ./programs/fzf.nix
    ./programs/zsh.server.nix
    ./programs/git.server.nix
    ./programs/tmux.server.nix
    ./programs/oh-my-posh.server.nix
    ./devel.nix
    #    ./programs/nvim.nix
    ./programs/lazygit.nix
    ./programs/ripgrep.nix
    ./programs/zig.nix
  ];
}
