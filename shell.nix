{pkgs}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs;
    [home-manager]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [cryptsetup];
}
