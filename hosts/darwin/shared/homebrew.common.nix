{
  homebrew = {
    enable = true;
    # caskArgs.no_quarantine = true;
    onActivation = {
      cleanup = "zap";
      extraFlags = [
        "--force-cleanup"
      ];
    };
    global.brewfile = true;
    masApps = {};
    casks = [
      "1password" # <- nix version is marked as broken
      "android-studio"
      "docker-desktop"
      "helium-browser"
      "google-chrome"
      # "vicinae"
    ];
    taps = [
      #"modem-dev/tap"
    ];
    brews = [
      "kcov"
    ];
  };
}
