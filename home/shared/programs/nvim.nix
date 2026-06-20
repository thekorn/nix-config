{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [pkgs.neovim];

  xdg.configFile."nvim".source = inputs.config-nvim;
}
