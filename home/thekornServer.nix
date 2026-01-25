{pkgs, ...}: {
  imports = [
    #    ./shared/common.nix
    #    ./shared/common.linux.nix
    #    ./shared/common.packages.server.nix
    #    ./shared/common.programs.server.nix
  ];

  programs.home-manager.enable = true;
  #programs.wayvnc.enable = true;
  services.wayvnc.enable = true;
  services.wayvnc.autoStart = true; #maybe: false
  services.wayvnc.settings = {
    address = "localhost";
    port = 5900;
  };

  home.stateVersion = "25.05";

  services.ssh-agent.enable = true;
  programs.ssh.addKeysToAgent = "yes";
}
