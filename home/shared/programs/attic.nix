{
  config,
  lib,
  pkgs,
  users,
  ...
}: let
  enabled = config.home.username != users.work;
  atticConfig = "${config.xdg.configHome}/attic/config.toml";
  watchStore = pkgs.writeShellScript "attic-watch-store" ''
    while [[ ! -s "${atticConfig}" ]]; do
      sleep 60
    done

    exec ${lib.getExe pkgs.attic-client} watch-store home:home
  '';
in
  lib.mkIf enabled (lib.mkMerge [
    {
      home.packages = [pkgs.attic-client];
    }

    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      systemd.user.services.attic-watch-store = {
        Unit = {
          Description = "Upload new Nix store paths to the home Attic cache";
          After = ["network-online.target"];
        };
        Service = {
          ExecStart = watchStore;
          Restart = "on-failure";
          RestartSec = 60;
        };
        Install.WantedBy = ["default.target"];
      };
    })

    (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      launchd.agents.attic-watch-store = {
        enable = true;
        config = {
          ProgramArguments = [(toString watchStore)];
          RunAtLoad = true;
          KeepAlive = true;
          ProcessType = "Background";
          ThrottleInterval = 60;
        };
      };
    })
  ])
