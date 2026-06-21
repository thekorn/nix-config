{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.ghostty;
  tmuxConfig = "${config.home.homeDirectory}/.config/tmux/tmux.conf";
  ghosttyTmux = pkgs.writeShellScriptBin "ghostty-tmux" ''
    exec ${pkgs.tmux}/bin/tmux -f /dev/null start-server \; source-file "${tmuxConfig}" \; new-session -A -s default
  '';
in {
  options.custom.ghostty = {
    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 12;
      description = "Font size for Ghostty terminal";
    };
  };

  config.programs.tmux = {
    enable = true;
  };

  config.programs.ghostty = {
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
      command = "${ghosttyTmux}/bin/ghostty-tmux";
      cursor-style-blink = true;
      shell-integration-features = "no-cursor, sudo, title";
      config-file = "?custom";
    };
  };
}
