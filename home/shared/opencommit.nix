{pkgs, ...}: {
  home.file = {".config/opencommit.env".source = ./dotfiles/opencommit.env;};
}
