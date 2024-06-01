{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = ["transmission" "discord" "whatsapp" "sonos" "arc"];
    brews = ["pkg-config" "cmake" "qt" "ninja" "ccache"];
    taps = ["homebrew/cask-versions"];
  };
}
