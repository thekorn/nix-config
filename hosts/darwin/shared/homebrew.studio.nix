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
      "multipass"
      #"antigravity"
      # "utm"
      # "nvidia-geforce-now"
    ];
    brews = [
    ];
  };
}
