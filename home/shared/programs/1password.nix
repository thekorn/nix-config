{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom."1password";
in {
  options.custom."1password".enable = lib.mkEnableOption "1Password CLI";
  config.home.packages = lib.mkIf cfg.enable (with pkgs; [
    _1password-cli
    #_1password-gui # is marked as broken
  ]);
}
