{
  config,
  inputs,
  lib,
  pkgs,
  users,
  ...
}: let
  runnerSecretFile = ../../secrets/thekorn-server/github-runner-bunte-app;
  runnerSecretAvailable = builtins.pathExists runnerSecretFile;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./configurations/thekorn-server/hardware-configuration.nix
    ./shared/amp-runner.nix
    ./shared/attic.nix
    ./shared/home.private.nix
    ./shared/virtualisation.nix
  ];

  system.stateVersion = "25.11";

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "thekorn-server";
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

  # Reuse the server's SSH Ed25519 identity; private key never enters the store.
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  sops.gnupg.sshKeyPaths = [];
  sops.secrets.github-runner-bunte-app = lib.mkIf runnerSecretAvailable {
    sopsFile = runnerSecretFile;
    format = "binary";
    owner = "root";
    group = "root";
    mode = "0400";
    restartUnits = ["github-runner-bunte-app.service"];
  };

  warnings = lib.optional (!runnerSecretAvailable) ''
    GitHub runner still uses its manually provisioned token. Follow docs/secrets.md
    to add secrets/thekorn-server/github-runner-bunte-app and enable sops-nix.
  '';

  services.github-runners.bunte-app = {
    enable = true;
    name = "thekorn-server-bunte-app";
    url = "https://github.com/thekorn/bunte-app";
    # Keep the existing runner working until the encrypted token is provisioned.
    tokenFile =
      if runnerSecretAvailable
      then config.sops.secrets.github-runner-bunte-app.path
      else "/var/lib/github-runner-secrets/bunte-app.token";
    extraLabels = ["nixos" "thekorn-server"];
    # TCP 5037 (ADB) and 5630-5633 (emulators) are reserved by host convention for this runner.
    # Personal/local Android sessions must use different ports.
    extraPackages = [pkgs.iproute2];
    serviceOverrides = {
      PrivateDevices = false;
      DevicePolicy = "closed";
      DeviceAllow = ["/dev/kvm rw"];
    };
  };

  home-manager.users.${users.private} = {
    imports = [
      ../../home/shared/profiles/linux-server.nix
      ../../home/shared/private.nix
    ];

    custom.git.commitMessageModel = "gpt-5.6-luna";
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
