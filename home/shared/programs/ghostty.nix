{pkgs, config, lib, ...}: let
  cfg = config.custom.ghostty;
in {
  options.custom.ghostty = {
    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 12;
      description = "Font size for Ghostty terminal";
    };
  };
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableZshIntegration = true;
    settings = {
      theme = "nord";
      font-family = "GeistMono Nerd Font";
      font-size = cfg.fontSize;
      font-thicken = true;
      confirm-close-surface = false;
      auto-update = "off";
      copy-on-select = "clipboard";
      quit-after-last-window-closed = true;
      cursor-style-blink = true;
      shell-integration-features = "no-cursor, sudo, title";
      config-file = "?custom";
    };
  };
}
