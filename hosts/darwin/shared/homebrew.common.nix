{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation.cleanup = "zap";
    global.brewfile = true;
    masApps = {};
    casks = [
      "1password" # <- nix version is marked as broken
      "android-studio"
      "docker-desktop" # <-- podman does not work for CTF
      #"antigravity" <-- not working with my current google workspace subscription
      "helium-browser"
    ];
    taps = [];
    brews = [
      "gemini-cli" # <-- nix version is outdated
    ];
  };
}
