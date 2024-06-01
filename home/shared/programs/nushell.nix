{pkgs, ...}: {
  home.packages = with pkgs; [oh-my-posh nushell];
  home.file = {
    ".config/nushell/oh-my-posh.nu".source = ./dotfiles/nushell/oh-my-posh.nu;
    ".config/nushell/powerlevel10k_rainbow.json".source =
      ./dotfiles/oh-my-posh/powerlevel10k_rainbow.omp.json;
    ".config/nushell/dracula.json".source =
      ./dotfiles/oh-my-posh/dracula.omp.json;
    "/Users/thekorn/Library/Application Support/nushell/env.nu".source =
      ./dotfiles/nushell/env.nu;
    "/Users/thekorn/Library/Application Support/nushell/config.nu".source =
      ./dotfiles/nushell/config.nu;
  };
}
