{
  pkgs,
  config,
  ...
}: {
  programs.kitty = {
    enable = true;
    theme = "Nord";
  };
}
