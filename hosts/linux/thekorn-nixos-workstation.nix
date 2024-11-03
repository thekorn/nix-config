{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./configurations/thekornNixOSWorkstation/hardware-configuration.nix
    ./shared/programs/fonts.nix
    ./shared/programs/home.private.nix
  ];

  networking.hostName = "thekorn-nixos-workstation";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;

  system.stateVersion = "23.05"; # Did you read the comment?

  services.sshd.enable = true;

  programs.zsh.enable = true;
  programs.hyprland.enable = true;
  environment = {
    shells = with pkgs; [bash zsh];
    systemPackages = [pkgs.coreutils];
    #systemPath = [ "/opt/homebrew/bin" ];
    #pathsToLink = [ "/Applications" ];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  #services.nix-daemon.enable = true;
}
