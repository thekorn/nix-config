{ pkgs, config, ... }: {

  home.file."/.config/alacritty/nord.theme.yml".source =
    ./dotfiles/alacritty/nord.theme.yml;
  programs.alacritty = {
    enable = true;
    settings = {
      # workaround for now
      # will be fixed in 0.12
      # https://github.com/alacritty/alacritty/issues/1349
      window = { option_as_alt = "Both"; };
      font = {
        normal.family = "MesloLGS Nerd Font Mono";
        size = 12;
      };
      import = [ "~/.config/alacritty/nord.theme.yml" ];
      selection = { save_to_clipboard = true; };
    };
  };
}
