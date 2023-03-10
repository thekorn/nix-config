{ pkgs, ... }: {
  # here go the darwin preferences and config items

  imports = [
      ./shared/homebrew.nix
      ./shared/fonts.nix
      ./shared/system.nix
      #./features/laptop.nix
      #./features/noto-fonts.nix
      #./features/wayland.nix
      #./features/flatpak.nix
      #./features/firewall.nix
      #./users/maturana.nix
  ];


  programs.zsh.enable = true;
  environment = {
    shells = with pkgs; [ bash zsh ];
    loginShell = pkgs.zsh;
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  services.nix-daemon.enable = true;

}