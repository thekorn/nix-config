{pkgs, ...}: {
  home.packages = with pkgs; [open-interpreter];
  home.file = {
    ".config/openinterpreter.env".source = ./dotfiles/openinterpreter.env;
  };
  programs.zsh.shellAliases = {
    interpreter = ''op run --env-file="$HOME/.config/openinterpreter.env" -- interpreter'';
  };
}
