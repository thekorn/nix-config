{pkgs, ...}: {
  home.packages = with pkgs; [
    qmk
    wb32-dfu-updater
  ];
}
