{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.ghostty;
  startTmux = pkgs.writeShellScriptBin "ghostty-start-tmux" ''
    #!/bin/zsh
    SESSION_NAME="ghostty"

    # Check if the session already exists
    ${pkgs.tmux}/bin/tmux has-session -t $SESSION_NAME 2>/dev/null

    if [ $? -eq 0 ]; then
     # If the session exists, reattach to it
     ${pkgs.tmux}/bin/tmux attach-session -t $SESSION_NAME
    else
     # If the session doesn't exist, start a new one
     ${pkgs.tmux}/bin/tmux new-session -s $SESSION_NAME -d
     ${pkgs.tmux}/bin/tmux attach-session -t $SESSION_NAME
    fi
  '';
in {
  options.custom.ghostty = {
    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 12;
      description = "Font size for Ghostty terminal";
    };
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
      cursor-style-blink = true;
      shell-integration-features = "no-cursor, sudo, title";
      config-file = "?custom";
      #command = "/etc/profiles/per-user/thekorn/bin/tmux new-session -A -t ghostty";
      command = "${startTmux}/bin/ghostty-start-tmux";
    };
  };
}
