{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = [
      "transmission"
      "discord"
      #"whatsapp"
      "sonos"
    ];
    brews = ["autoconf" "autoconf-archive" "automake" "ccache" "cmake" "ffmpeg" "nasm" "ninja" "pkg-config"];
    taps = ["homebrew/cask-versions"];
  };
}
