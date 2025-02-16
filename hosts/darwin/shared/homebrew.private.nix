{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = [
      "transmission"
      "sonos"
    ];
    brews = [];
    taps = ["homebrew/cask-versions"];
  };
}
