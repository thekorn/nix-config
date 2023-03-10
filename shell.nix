{pkgs}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    home-manager
    cryptsetup
  ];
}
