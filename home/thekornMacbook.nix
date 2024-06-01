{pkgs, ...}: {
  imports = [
    ./shared/common.nix
    ./shared/common.darwin.nix
    ./shared/common.packages.nix
    ./shared/common.programs.nix
    ./shared/devel.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";
}
