{pkgs, ...}: {
  home.file = {".config/gptcommit.env".source = ./dotfiles/gptcommit.env;};
  home.packages = with pkgs; [gptcommit];
}
