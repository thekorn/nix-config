{pkgs, ...}: {
  home.packages = with pkgs; [xcodes];
  home.file = {".config/xcodes.env".source = ./dotfiles/xcodes.env;};
}
