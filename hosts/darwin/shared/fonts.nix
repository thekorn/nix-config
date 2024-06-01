{pkgs, ...}: {
  fonts.fontDir.enable = true; # DANGER
  fonts.fonts = [(pkgs.nerdfonts.override {fonts = ["Meslo" "CascadiaCode"];})];
}
