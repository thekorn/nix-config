{...}: {
  imports = [
    ../profiles/linux-server.nix
  ];

  services.wayvnc.enable = true;
  services.wayvnc.autoStart = true;
  services.wayvnc.settings = {
    address = "localhost";
    port = 5900;
  };

  home.stateVersion = "25.05";
}
