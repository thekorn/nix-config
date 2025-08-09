{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./configurations/thekorn-server2/hardware-configuration.nix
    #./shared/virtualisation.nix
  ];

  # Machine-specific configuration for thekorn-server2
  # All other configuration comes from profiles: ["server", "private"]

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thekorn-server2";

  # Override system state version for this specific server
  system.stateVersion = "25.05";
}
