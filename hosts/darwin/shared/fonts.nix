{pkgs, ...}: {
  fonts.packages = [(pkgs.nerdfonts.override {fonts = ["Meslo" "CascadiaCode"];})];
}
