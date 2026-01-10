{pkgs, ...}: {
  imports = [
    ./shared/common.nix
    ./shared/common.darwin.nix
    ./shared/common.packages.nix
    ./shared/common.programs.nix
    ./shared/devel.nix

    ./shared/programs/zig.nix
  ];

  home.packages = with pkgs; [
    zulu25
    discord
    biome
    bun
    #whatsapp-for-mac
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";
}
