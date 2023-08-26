{ pkgs, ... }: {
  fonts.fontDir.enable = true; # DANGER
  fonts.packages =
    [ (pkgs.nerdfonts.override { fonts = [ "Meslo" "CascadiaCode" ]; }) ];
}
