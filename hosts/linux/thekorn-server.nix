# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  inputs,
  pkgs,
  users,
  ...
}: {
  imports = [
    inputs.omarchy-nix.nixosModules.default

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
    packages = with pkgs; [git htop tree];
    shell = pkgs.bash;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    coreutils
    nodejs
  ];
  environment.shells = with pkgs; [bash zsh];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  #networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
  nix.settings.experimental-features = ["nix-command" "flakes"];

  omarchy = {
    username = users.private;
    full_name = "Markus Korn";
    email_address = "markus.korn@gmail.com";
    theme = "tokyo-night";
    seamless_boot = {
      enable = true; # Enable Plymouth + auto-login
      username = users.private; # Required for auto-login
      plymouth_theme = "omarchy"; # Custom boot splash theme
      silent_boot = true; # Hide kernel messages
    };
    monitors = [
      # "HDMI-A-1,2560x1440,auto,1,transform,1" # External monitor, 1x scaling, rotate 90deg
      "HDMI-A-1,3140x2610,auto,1"
    ];
    firewall.enable = true;
    quick_app_bindings = [
      "ALT_L, RETURN, Terminal, exec, $terminal"
      "ALT_L, SPACE, Launch apps, exec, omarchy-launch-walker"
      "ALT_L, K, Show key bindings, exec, omarchy-show-keybindings"
    ];
  };

  home-manager.users.${users.private} = {
    imports = [
      inputs.omarchy-nix.homeManagerModules.default
      ../../home/shared/profiles/linux-server.nix
    ];

    #programs.wayvnc.enable = true;
    services.wayvnc.enable = true;
    services.wayvnc.autoStart = true; #maybe: false
    services.wayvnc.settings = {
      address = "localhost";
      port = 5900;
    };
  };
}
