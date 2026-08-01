{
  pkgs,
  username,
  ...
}: {
  homebrew.brews = [
    "autoconf"
    "autoconf-archive"
    "automake"
    "ccache"
    "cmake"
    "libtool"
    "nasm"
    "ninja"
    "pkg-config"
    "llvm@20"
  ];

  home-manager.users.${username}.home.packages = with pkgs;
    [
      cargo
      rustc
    ]
    ++ lib.optionals (!stdenv.isDarwin) [
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
