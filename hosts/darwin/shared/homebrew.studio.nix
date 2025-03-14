{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = [
      "proxyman"
      "obs"
      "steam"
    ];
    brews = [
    ];
  };
}
