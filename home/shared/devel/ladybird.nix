{
  pkgs,
  username,
  ...
}: {
  # in case the nix packages dont work on darwin...
  #homebrew.brews = pkgs.lib.optionals (pkgs.stdenv.hostPlatform.isDarwin) [
  #  "autoconf"
  #  "autoconf-archive"
  #  "automake"
  #  "ccache"
  #  "cmake"
  #  "libtool"
  #  "nasm"
  #  "ninja"
  #  "pkg-config"
  #  "llvm@20"
  #];

  home-manager.users.${username}.home.packages = with pkgs; [
    cargo
    rustc
    autoconf
    autoconf-archive
    automake
    ccache
    cmake
    ffmpeg
    libtool
    llvm
    nasm
    ninja
    pkg-config
  ];
}
