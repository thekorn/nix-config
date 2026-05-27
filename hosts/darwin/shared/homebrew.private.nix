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
      "chatgpt" # <- nix version is outdated
      # "antigravity-ide"
      # "antigravity-cli"
    ];
    brews = [];
    taps = [];
  };
}
