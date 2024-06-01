{
  pkgs,
  config,
  ...
}: {
  programs.bat.enable = true;
  programs.bat.config.theme = "Nord";
}
