{pkgs, ...}: {
  home.packages = with pkgs; [
    autoconf
    autoconf-archive
    automake
    cmake
    ninja
    ccache
    pkg-config
  ];
}
