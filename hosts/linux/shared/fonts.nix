{pkgs, ...}: {
  fonts.fontDir.enable = true; # DANGER
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
    nerd-fonts.caskaydia-cove
    nerd-fonts.geist-mono
    nerd-fonts.monaspace
  ];
}
