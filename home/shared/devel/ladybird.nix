{
  lib,
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
    (
      if stdenv.hostPlatform.isDarwin
      then
        ccache.overrideAttrs (old: {
          # FIXME: remove when nixpkgs limits elfutils to Linux. ccache's tests
          # use eu-elfcmp only on Linux; keep the Darwin tests enabled.
          nativeCheckInputs = lib.filter (input: lib.getName input != "elfutils") old.nativeCheckInputs;

          # Nix's Clang wrapper injects flags unused by the preprocessed-input
          # and C++ module tests, which require otherwise empty stderr.
          preCheck =
            old.preCheck
            + ''
              export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-unused-command-line-argument"
            '';
        })
      else ccache
    )
    cmake
    ffmpeg
    libtool
    llvm
    nasm
    ninja
    pkg-config
  ];
}
