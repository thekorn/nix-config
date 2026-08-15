{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.custom.ghostty;
  tmuxConfig = "${config.home.homeDirectory}/.config/tmux/tmux.conf";
  # Ghostty launches with a minimal PATH; prepend deps needed to load tmux plugins.
  pluginPath = lib.makeBinPath [pkgs.tmux pkgs.bash pkgs.coreutils] + ":/usr/bin:/bin";
  ghosttyTmux = pkgs.writeShellScriptBin "ghostty-tmux" ''
    export PATH="${pluginPath}:$PATH"
    exec ${pkgs.tmux}/bin/tmux -f /dev/null start-server \; source-file "${tmuxConfig}" \; new-session -A -s default
  '';
  ghosttyPackage =
    if pkgs.stdenv.hostPlatform.isDarwin
    then pkgs.ghostty-bin
    else
      pkgs.symlinkJoin {
        name = "ghostty-wrapped";
        paths = [pkgs.ghostty];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          rm "$out/bin/ghostty"
          makeWrapper ${pkgs.ghostty}/bin/ghostty "$out/bin/ghostty" \
            --set LIBGL_ALWAYS_SOFTWARE 1
        '';
        inherit (pkgs.ghostty) meta;
      };
in {
  options.custom.ghostty = {
    enable = lib.mkEnableOption "Ghostty";
    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 12;
      description = "Font size for Ghostty terminal";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tmux.enable = true;
    programs.ghostty = {
      enable = true;
      package = ghosttyPackage;
      enableZshIntegration = true;
      settings =
        {
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
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
          theme = "nord";
        };
    };
  };
}
