{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = [
      "transmission"
      "pocket-casts"
      "affinity"
      "antigravity-ide"
      "antigravity-cli"
    ];
    brews = [];
    taps = [];
  };
}
