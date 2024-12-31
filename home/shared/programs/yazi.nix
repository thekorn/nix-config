{pkgs, ...}: {
  home.file = {".config/yazi/yazi.toml".source = ./dotfiles/yazi/yazi.toml;};
  home.packages = with pkgs; [yazi];
}
