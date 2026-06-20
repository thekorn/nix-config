{
  pkgs,
  users,
  ...
}: {
  imports = [
    ./shared/homebrew.common.nix
    ./shared/homebrew.work.nix
    ./shared/home.work.nix
    ./shared/fonts.nix
    (import ./shared/preferences.nix {
      inherit pkgs;
      username = users.work;
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
  nix.enable = false;
  ids.gids.nixbld = 30000;

  home-manager.users.${users.work} = {pkgs, ...}: {
    imports = [
      ../../home/shared/profiles/darwin.nix
      ../../home/shared/work.nix
    ];

    home.packages = with pkgs; [
      zulu17
    ];

    custom = {
      ghostty.fontSize = 19;
      workmux.defaultAgent = "cursor-agent";
    };
  };
}
