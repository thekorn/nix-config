{
  lib,
  pkgs,
  users,
  ...
}:
{
  imports = [
    ./configurations/thekorn-vm-utm/hardware-configuration.nix
    ./shared/home.private.nix
  ];

  system.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "thekorn-vm-utm";
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

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.graphics.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  services.displayManager = {
    defaultSession = "hyprland-uwsm";
    autoLogin = {
      enable = true;
      user = users.private;
    };
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  security.polkit.enable = true;

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  environment.sessionVariables = {
    AQ_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  environment.shells = with pkgs; [
    bash
    zsh
  ];
  environment.systemPackages = with pkgs; [
    neovim
    wget
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  home-manager.users.${users.private} = { pkgs, ... }: {
    imports = [
      ../../home/shared/profiles/linux-vm-desktop.nix
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
