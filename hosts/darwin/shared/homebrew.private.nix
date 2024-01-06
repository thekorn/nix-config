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
      "keymapp"
      "whatsapp"
      "zulu8"
      "zulu11"
      "zulu17"
      "sonos"
    ];
    brews = [ "pkg-config" "qmk/qmk/qmk" "cmake" "qt" "ninja" "ccache" ];
    taps = [ "homebrew/cask-versions" ];
  };
}
