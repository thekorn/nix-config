{pkgs, ...}: {
  home.packages = with pkgs; [zed-editor]; #<- unstable package, broken on darwin, using homebrew for now
  # config is now manged in https://github.com/thekorn/zed-config
  #home.file = {
  #  ".config/zed/settings.json".source = ./dotfiles/zed/settings.json;
  #  ".config/zed/themes/nord.json".source = ./dotfiles/zed/nord.json;
  #};
}
