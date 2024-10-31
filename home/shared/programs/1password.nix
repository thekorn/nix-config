{pkgs, ...}: {
  home.packages = with pkgs; [
    _1password-cli
    #_1password-gui # this is not working as expected, still need the homebrew package on mac
  ];
}
