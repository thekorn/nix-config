{
  lib,
  pkgs,
  users,
  ...
}: {
  imports = [
    ./configurations/thekorn-server-2/hardware-configuration.nix
    ./shared/amp-runner.nix
    ./shared/home.private.nix
    ./shared/virtualisation.nix
  ];

  system.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "thekorn-server-2";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  environment.shells = with pkgs; [bash zsh];
  environment.systemPackages = with pkgs; [
    neovim
    wget
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users.${users.private}.extraGroups = ["dialout"];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="303a", ATTR{idProduct}=="1001", GROUP="dialout", MODE="0660"
  '';

  home-manager.users.${users.private} = {
    imports = [
      ../../home/shared/profiles/linux-server.nix
      ../../home/shared/private.nix
    ];
  };

  # dbus-broker does not reload reliably during remote activation; failed
  # reloads make nixos-rebuild exit non-zero even when the system switched.
  systemd.services.dbus-broker = {
    reloadIfChanged = lib.mkForce false;
    restartIfChanged = lib.mkForce false;
  };
  systemd.user.services.dbus-broker = {
    reloadIfChanged = lib.mkForce false;
    restartIfChanged = lib.mkForce false;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
