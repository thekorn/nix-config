{
  pkgs,
  config,
  ...
}: {
  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;
  programs.ssh.settings = {
    "*" = {
      ForwardAgent = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      Compression = false;
      AddKeysToAgent = "no";
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
      IdentityAgent = "'~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock'";
    };
  };
}
