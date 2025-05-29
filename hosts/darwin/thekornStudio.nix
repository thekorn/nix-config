{pkgs, ...}: {
  # here go the darwin preferences and config items

  imports = [
    ./shared/homebrew.common.nix
    ./shared/homebrew.studio.nix
    ./shared/homebrew.private.nix
    ./shared/homebrew.ladybird.nix
    ./shared/home.private.nix
    ./shared/fonts.nix
    #./shared/preferences.nix
    (import ./shared/preferences.nix {
      inherit pkgs;
      username = "thekorn";
    })
  ];

  system.stateVersion = 5;

  programs.zsh.enable = true;
  environment = {
    shells = with pkgs; [bash zsh];
    systemPackages = [pkgs.coreutils];
    systemPath = ["/opt/homebrew/bin"];
    pathsToLink = ["/Applications"];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  #ids.gids.nixbld = 30000;
  nix.enable = false;
}
