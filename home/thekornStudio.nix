{pkgs, ...}: {
  imports = [
    ./shared/programs/qmk.nix

    ./shared/common.nix
    ./shared/common.darwin.nix
    ./shared/common.packages.nix
    ./shared/common.programs.nix
    ./shared/devel.nix
    ./shared/work.nix
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";
}
