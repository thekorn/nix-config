{ pkgs, lazyvim, ... }: {
  home.packages = with pkgs; [ neovim ];

  home.file = { ".config/nvim".source = lazyvim; };
}
