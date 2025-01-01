{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = [
      "transmission"
      "discord"
      "whatsapp"
      "sonos"
      "zulu"
    ];
    brews = [];
    taps = ["homebrew/cask-versions"];
  };
}
