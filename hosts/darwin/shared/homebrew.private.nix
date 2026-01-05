{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = [
      "transmission"
      "pocket-casts"
    ];
    brews = [];
    taps = [];
  };
}
