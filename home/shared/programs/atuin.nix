{pkgs, ...}: {
  home.packages = with pkgs; [atuin];
  home.file."/.config/atuin/config.toml".source = ./dotfiles/atuin/config.toml;
  programs.zsh = {initContent = ''eval "$(atuin init zsh)"'';};
}
