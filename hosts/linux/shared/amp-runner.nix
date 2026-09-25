{
  config,
  lib,
  pkgs,
  users,
  ...
}: let
  homeDirectory = config.users.users.${users.private}.home;
  discoveryDirectory = "${homeDirectory}/devel";
in {
  options.custom.ampRunner.runnerId = lib.mkOption {
    type = lib.types.str;
    default = config.networking.hostName;
    defaultText = lib.literalExpression "config.networking.hostName";
    description = "Runner ID used to register this machine with Amp.";
  };

  config = {
    environment.systemPackages = [pkgs.llm-agents.amp];

    systemd.services.amp-runner = {
      description = "Amp runner";
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = ["network-online.target"];
      environment.HOME = homeDirectory;
      serviceConfig = {
        User = users.private;
        WorkingDirectory = "/tmp";
        ExecStart = "${pkgs.llm-agents.amp}/bin/amp --no-tui --runner-id ${config.custom.ampRunner.runnerId} --discover-dirs=${discoveryDirectory} --discover-depth 3 --remote-control-terminal --amp-env";
        Restart = "always";
        RestartSec = 5;
      };
      path = with pkgs; [
        tmux
      ];
    };
  };
}
