{pkgs, ...}: {
  imports = [
    ../profiles/darwin-desktop.nix
    ../profiles/work.nix
  ];

  home.packages = with pkgs; [
    zulu25
  ];
}
