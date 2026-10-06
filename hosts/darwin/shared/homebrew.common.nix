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
      "cursor"
      "steipete/tap/codexbar"
      "abue-ammar/tinycast/tinycast"
      #"orchard"
    ];
    taps = [
      #"modem-dev/tap"
      "steipete/tap"
      "abue-ammar/tinycast"
    ];
    brews = [
      "kcov"
      "container" #<-- nix version is vendored, and still broken
    ];
  };
}
