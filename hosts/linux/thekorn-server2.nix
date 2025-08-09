{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./configurations/thekorn-server2/hardware-configuration.nix
    ./shared/home.private.nix
    #./shared/virtualisation.nix
    ../../profiles/nixos/server.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thekorn-server2";

  # Override system state version for this specific server
  system.stateVersion = "25.05";
}
