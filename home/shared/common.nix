{pkgs, ...}: {
  imports = [
    ./programs/1password.nix
    ./programs/bat.nix
    ./programs/eza.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/git.server.nix
    ./programs/git.common.nix
    ./programs/git-codex-commit-message.nix
    ./programs/git-amp-commit-message.nix
    ./programs/git-cursor-commit-message.nix
    ./programs/hunk.nix
    ./programs/tmux.nix
    ./programs/tmux.server.nix
    ./programs/tmux.common.nix
    ./programs/zsh.darwin.nix
    ./programs/zsh.linux.nix
    ./programs/zsh.common.nix
    ./programs/zsh-plugins.nix
    ./programs/oh-my-posh.nix
    ./programs/oh-my-posh.server.nix
    ./programs/ssh.nix
    ./programs/nvim.nix
    ./programs/bottom.nix
    ./programs/lazygit.nix
    ./programs/ripgrep.nix
    ./programs/atuin.nix
    ./programs/zed.nix
    ./programs/pnpm.nix
    ./programs/bun.nix
    ./programs/android-studio.nix
    ./programs/dart-cli.nix
    ./programs/btop.nix
    ./programs/vscode.nix
    ./programs/ghostty.nix
    ./programs/mpv.nix
    ./programs/fvm.nix
    ./programs/codebook.nix
    ./programs/workmux.nix
    ./programs/herdr.nix
    ./programs/zig.nix
  ];

  home.sessionVariables = {
    PAGER = "less";
    CLICOLOR = 1;
    EDITOR = "nvim";
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/local/share";

    # superfile needs xdg config home
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  home.sessionPath = [
    "$HOME/.pub-cache/bin"
    "$HOME/.local/bin"
  ];
}
