{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
    nerd-fonts.caskaydia-cove
    nerd-fonts.geist-mono
  ];
}
