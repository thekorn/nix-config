{...}: {
  imports = [
    ../home/shared/common.nix
    ../home/shared/common.linux.nix
    ../home/shared/common.packages.server.nix
    ../home/shared/common.programs.server.nix
  ];

  programs.home-manager.enable = true;

  services.ssh-agent.enable = true;
  programs.ssh.addKeysToAgent = "yes";
}
