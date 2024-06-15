{pkgs, ...}: {
  imports = [
    ./programs/1password.nix
    ./programs/alacritty.nix
    ./programs/bat.nix
    ./programs/eza.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/tmux.nix
    ./programs/zsh.nix
    ./programs/ssh.nix
    ./programs/nvim.nix
    ./programs/bottom.nix
    ./programs/lazygit.nix
    ./programs/ripgrep.nix
    ./programs/gptcommit.nix
    ./programs/atuin.nix
    ./programs/zed.nix
    ./programs/oh-my-posh.nix
    # workaround, zig nix is broken https://github.com/NixOS/nixpkgs/issues/317055
    # using brew for now
    # ./programs/zig.nix
    ./programs/pnpm.nix
    ./programs/android-studio.nix
    ./programs/dart-cli.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";
}
