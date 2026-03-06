{
  primaryUser,
  pkgs,
  ...
}: {
  imports = [
    ./fonts.nix
    ./preferences.nix
    ./homebrew.common.nix
  ];

  users.users.${primaryUser}.home = "/Users/${primaryUser}";

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
}
