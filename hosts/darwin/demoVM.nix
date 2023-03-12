{ pkgs, ... }: {
  # here go the darwin preferences and config items

  imports =
    [ ./shared/homebrew.nix ./shared/fonts.nix ./shared/preferences.nix ];

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
