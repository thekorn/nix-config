{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation {
  name = "zigup";
  src = pkgs.fetchurl {
    url = "https://github.com/marler8997/zigup/releases/download/v2024_05_05/zigup-aarch64-macos.tar.gz";
    sha256 = "13ci0jpl6whf1qnlc32jkb8jdvqyn4y1l4iczr17mn9krwzz6b1i";
  };
  phases = ["installPhase" "patchPhase"];
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/zigup
    chmod +x $out/bin/zigup
  '';
}
