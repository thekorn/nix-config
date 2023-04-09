{ pkgs, config, ... }: {

  home.file."/.config/alacritty/nord.theme.yml".source =
    ./dotfiles/alacritty/nord.theme.yml;
  programs.alacritty = {
    enable = true;
    settings = {
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
