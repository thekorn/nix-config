{
  config,
  pkgs,
  users,
  ...
}: let
  homeDirectory = config.users.users.${users.private}.home;
  discoveryDirectory = "${homeDirectory}/devel";
in {
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
      # ExecStart = "${pkgs.llm-agents.amp}/bin/amp --no-tui --runner-id ${config.networking.hostName} --discover-dirs=${discoveryDirectory} --discover-depth 3 --remote-control-terminal --amp-env";
      ExecStart = "${pkgs.llm-agents.amp}/bin/amp --no-tui --runner-id ${config.networking.hostName} --discover-dirs=${discoveryDirectory} --discover-depth 3 --remote-control-terminal";
      Restart = "always";
      RestartSec = 5;
    };
    path = with pkgs; [
      tmux
    ];
  };
}
