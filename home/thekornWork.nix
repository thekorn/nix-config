{pkgs, ...}: {
  imports = [
    ./shared/common.nix
    ./shared/common.darwin.nix
    ./shared/common.packages.nix
    ./shared/common.programs.nix
    ./shared/devel.nix
    ./shared/work.nix
  ];

  home.packages = with pkgs; [
    zulu23
    mongodb-compass
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";
}
