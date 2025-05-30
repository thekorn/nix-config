{pkgs, ...}: {
  imports = [
    ./shared/programs/qmk.nix
    #./shared/programs/steam.nix

    ./shared/common.nix
    ./shared/common.darwin.nix
    ./shared/common.packages.nix
    ./shared/common.programs.nix
    ./shared/devel.nix
    ./shared/work.nix

    #./shared/programs/zig.nix

    # this would be great, but ladybird build fails with those
    # using homebrew for now
    #./shared/devel/ladybird.darwin.nix

    # package not working, use homebrew
    #./shared/devel/rpi.darwin.nix
    #./shared/programs/vendor/prismlauncher.nix
  ];

  home.packages = with pkgs; [
    zulu17
    #zulu21
    #zulu23

    #prismlauncher
    #chatgpt
    wb32-dfu-updater
    discord
    #whatsapp-for-mac
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "22.11";
}
