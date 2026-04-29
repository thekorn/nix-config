{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = [
      "figma"
      "cursor"
      "open-pencil/tap/open-pencil"
    ];
    taps = [
      "open-pencil/tap"
    ];
  };
}
