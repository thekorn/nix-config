{pkgs, ...}: {
  programs.oh-my-posh.enable = true;
  programs.oh-my-posh.settings = builtins.fromJSON (builtins.readFile ./dotfiles/oh-my-posh/powerlevel10k_rainbow.omp.json);
}
