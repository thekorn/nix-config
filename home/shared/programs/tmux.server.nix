{pkgs, ...}: {
  imports = [./tmux.common.nix];

  programs.tmux = {
    shortcut = "b";
  };
}
