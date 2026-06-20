# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./configurations/thekorn-server/hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thekorn-server"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thekorn = {
    isNormalUser = true;
    description = "thekorn";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5L9M3eLZlZNQKyxGFKBRHkklhu4vK8eR4gj9JBb08a1K9tJ5UnWaETGHWq+UM3C5RdYcc5ZGAyc30/9nzxLskb9zi7xo6/Exhn2myMs3Bcwq0d1l/OeBTtdwKdP9YGfnVgNk7ZoPZtNygQCUsd1XWGfqgpw0mQW7BNc+W3U7+i5MeAhoOBC9NVqx8/q/CWPo89S63UPolsiQfrv4paYDakx+yT0M1Wkh6jXvIGNsVRGL4BuqFhYhh5pckmAnPMuBTAQV9jrV4GnpZIF/Y4EGOCKFgeseCMWzX8bDaNeNwZHxKUjmNYLW9nN5ZcQ0UnAap+YlSPH2pGuLgUaN7SNB0nwL1nAEtJEh7cYRufQ2HVZBqUxR/8NoreXGelio0qHbEnF5OMC78KwGry2XmuMfB+Mtvmg2CmHJwqI8z5Vr9hh6vwr7EJV5luKgwOGjdbPKocHQSfwTNg4zdRtrEeumIBYVkFOdV4sAdiIlB+Jtn+o3ZKCpyIGQEoqfglG3FrX6bbWpdL5Ls0t5+JsNnny/Rz2o6PNax84Fgab98seRhdK5nG1q8O+Woz9OnstAFjU+A9Ex0XhLBazsrfpnR0ZY9gfqpUBb2EfwlRS00WmE02ay+4t7rZfkohGcC16ZmJIt8hd/K1wKDSs/CS9q81VGstlHQjRiIPs+LqPsqr6HUzQ=="
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    git
    neovim
    wget
    htop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "yes";
    };
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
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
