{ pkgs, ... }: {
  home.file = { ".config/xcodes.env".source = ./dotfiles/xcodes.env; };
}
