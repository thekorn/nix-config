{ pkgs, ... }: {
  home.packages = with pkgs; [ lazygit ];
  home.file = { ".config/lazygit/config.yml".source = ./dotfiles/lazygit.yml; };
}
