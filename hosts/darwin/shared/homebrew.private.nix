{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = ["transmission" "discord" "whatsapp" "sonos" "arc"];
    brews = ["autoconf" "autoconf-archive" "automake" "cmake" "ninja" "ccache" "pkg-config"];
    taps = ["homebrew/cask-versions"];
  };
}
