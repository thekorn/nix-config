{ pkgs, ... }: {
  home.packages = with pkgs; [ open-interpreter ];
  home.file = {
    ".config/openinterpreter.env".source = ./dotfiles/openinterpreter.env;
  };
}
