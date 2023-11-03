{ pkgs, ... }: {
  home.file = {
    ".config/openinterpreter.env".source = ./dotfiles/openinterpreter.env;
  };
}
