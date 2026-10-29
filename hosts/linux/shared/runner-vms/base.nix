{lib, ...}: {
  imports = [
    ../home.private.nix
    ../../../shared/attic-cache.nix
  ];

  system.stateVersion = "25.11";
  time.timeZone = "Europe/Berlin";
  networking.useDHCP = true;
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  security.sudo.wheelNeedsPassword = false;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];

  microvm = {
    hypervisor = "qemu";
    vcpu = lib.mkDefault 4;
    mem = lib.mkDefault 8192;
    # Ship the guest closure as a disk, never expose host filesystems.
    storeOnDisk = true;
    shares = [];
    writableStoreOverlay = "/nix/.rw-store";
    volumes = [
      {
        image = "root.img";
        label = "root";
        mountPoint = "/";
        size = 65536;
      }
    ];
  };
}
