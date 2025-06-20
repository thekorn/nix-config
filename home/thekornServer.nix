{pkgs, ...}: {
  imports = [
    ./shared/common.nix
    ./shared/common.linux.nix
    ./shared/common.packages.server.nix
    ./shared/common.programs.server.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  services.ssh-agent.enable = true;
  programs.ssh.addKeysToAgent = "yes";
}
