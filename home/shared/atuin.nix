{ pkgs, ... }: {
  home.packages = with pkgs; [ atuin ];
  home.file."/.config/atuin/config.toml".source = ./dotfiles/atuin/config.toml;
  programs.zsh = { initExtra = ''eval "$(atuin init zsh)"''; };
}
