{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = ["transmission" "discord" "whatsapp" "sonos" "arc"];
    brews = ["autoconf" "automake" "autoconf-archive"];
    taps = ["homebrew/cask-versions"];
  };
}
