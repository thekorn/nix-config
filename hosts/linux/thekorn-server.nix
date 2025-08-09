{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./configurations/thekorn-server/hardware-configuration.nix
    ./shared/home.private.nix
    #./shared/virtualisation.nix
    ../../profiles/nixos/server.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thekorn-server";
}
