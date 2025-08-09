{
  pkgs,
  users,
  username,
  ...
}: {
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