{pkgs, ...}: {
  programs.oh-my-posh.enable = true;
  programs.oh-my-posh.settings = builtins.fromJSON (builtins.readFile ./dotfiles/oh-my-posh/material.omp.json);
}
