{
  imports = [
    ../common.nix
    ../common.linux.nix
    ../common.packages.server.nix
    ../common.programs.server.nix
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";

  custom.tmux.server.statusBarBackgroundColor = "magenta";

  services.ssh-agent.enable = true;
  programs.ssh.settings."*".AddKeysToAgent = "yes";
}
