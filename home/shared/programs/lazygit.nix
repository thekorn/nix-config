{pkgs, ...}: {
  home.packages = with pkgs; [lazygit];
  home.file = {".config/lazygit/config.yml".source = ./dotfiles/lazygit.yml;};
  home.sessionVariables = {
    LG_CONFIG_FILE = "$HOME/.config/lazygit/config.yml";
  };
}
