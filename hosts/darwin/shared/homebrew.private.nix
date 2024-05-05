{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {
      UTM = 1538878817;
      "Microsoft Remote Desktop" = 1295203466;
      "Microsoft OneDrive" = 823766827;
    };
    casks = [
      "transmission"
      "discord"
      "whatsapp"
      "zulu8"
      "zulu11"
      "zulu17"
      "sonos"
      "arc"
    ];
    brews =
      [ "pkg-config" "qmk/qmk/qmk" "cmake" "qt" "ninja" "ccache" "zig" "zls" ];
    taps = [ "homebrew/cask-versions" ];
  };
}
