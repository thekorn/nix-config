{
  config,
  pkgs,
  users,
  ...
}: {
  environment.systemPackages = [pkgs.llm-agents.amp];

  systemd.services.amp-runner = {
    description = "Amp runner";
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target"];
    after = ["network-online.target"];
    environment.HOME = config.users.users.${users.private}.home;
    serviceConfig = {
      User = users.private;
      WorkingDirectory = config.users.users.${users.private}.home;
      ExecStart = "${pkgs.llm-agents.amp}/bin/amp --no-tui --runner-id ${config.networking.hostName} --remote-control-terminal";
      Restart = "always";
      RestartSec = 5;
    };
    path = with pkgs; [
      tmux
    ];
  };
}
