{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = [
      "obs"
      "steam"
      "parallels"
      #"antigravity"
      # "utm"
      # "nvidia-geforce-now"
    ];
    brews = [
    ];
  };
}
