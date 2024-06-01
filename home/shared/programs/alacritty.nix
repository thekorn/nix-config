{
  pkgs,
  config,
  ...
}: {
  home.file."/.config/alacritty/nord.theme.toml".source =
    ./dotfiles/alacritty/nord.theme.toml;
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        option_as_alt = "OnlyLeft";
        decorations = "Full";
      };
      font = {
        normal.family = "MesloLGS Nerd Font Mono";
        size = 12;
      };
      import = ["~/.config/alacritty/nord.theme.toml"];
      selection = {save_to_clipboard = true;};
    };
  };
}
