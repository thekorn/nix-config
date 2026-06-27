{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        option_as_alt = "OnlyLeft";
        decorations = "Full";
      };
      font = {
        normal.family = "MesloLGS Nerd Font Mono";
        #normal.family = "GeistMono Nerd Font";
        size = 12;
      };
      selection = {save_to_clipboard = true;};
    };
    theme = "nord";
  };
}
