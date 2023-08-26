{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./configurations/thekornNixOSVM/hardware-configuration.nix
    #./shared/homebrew.common.nix
    #./shared/homebrew.studio.nix
    #./shared/homebrew.private.nix
    #./shared/home.private.nix
    ./shared/fonts.nix
    #./shared/preferences.nix
  ];

  networking.hostName = "thekorn-nixos-vm";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;

  users.users.thekorn = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ git neovim htop tree ];
  };

  system.stateVersion = "23.05"; # Did you read the comment?

  services.sshd.enable = true;

  programs.zsh.enable = true;
  environment = {
    shells = with pkgs; [ bash zsh ];
    loginShell = pkgs.zsh;
    #systemPackages = [ pkgs.coreutils ];
    #systemPath = [ "/opt/homebrew/bin" ];
    #pathsToLink = [ "/Applications" ];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  #services.nix-daemon.enable = true;
}

