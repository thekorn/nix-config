{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = [
      "transmission"
      "pocket-casts"
      "vnc-viewer"
      "voiceink"
    ];
    brews = [];
    taps = [];
  };
}
