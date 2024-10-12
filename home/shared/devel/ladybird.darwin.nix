{pkgs, ...}: {
  home.packages = with pkgs; [
    autoconf
    autoconf-archive
    automake
    ccache
    cmake
    ffmpeg
    nasm
    ninja
    pkg-config
    llvm
  ];
}
