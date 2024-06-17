{pkgs, ...}: {
  home.file = {".config/btop/btop.conf".source = ./dotfiles/btop/btop.conf;};
  home.file = {".config/btop/themes/nord.theme".source = ./dotfiles/btop/nord.theme;};
  home.packages = with pkgs; [btop];
}
