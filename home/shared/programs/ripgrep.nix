{pkgs, ...}: {
  home.packages = with pkgs; [ripgrep];
  home.file = {".ripgreprc".source = ./dotfiles/.ripgreprc;};
}
