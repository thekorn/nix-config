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
    ./programs/pnpm.nix
    ./programs/android-studio.nix
    ./programs/dart-cli.nix
    ./programs/btop.nix
    ./programs/vscode.nix
    ./programs/ghostty.nix
    ./programs/yazi.nix
    #./programs/podman.nix #<-- podman does not work for CTF
    ./programs/llm.nix
    ./programs/mpv.nix
    ./programs/slumber.nix
    ./programs/google-chrome.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";
}
