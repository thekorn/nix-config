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
    ./shared/programs/nvim.nix
    ./shared/programs/bottom.nix
    ./shared/programs/lazygit.nix
    ./shared/programs/ripgrep.nix
    ./shared/programs/opencommit.nix
    ./shared/programs/openinterpreter.nix
    ./shared/programs/nushell.nix
    ./shared/programs/atuin.nix
    ./shared/programs/zed.nix
    ./shared/programs/android-studio.nix
    ./shared/programs/work.nix
    ./shared/programs/pnpm.nix
    ./shared/programs/zig.nix
    ./shared/programs/qmk.nix

    ./shared/common.nix
    ./shared/common.packages.nix
    ./shared/devel.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";
}
