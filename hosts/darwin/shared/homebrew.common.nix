{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = { };
    casks = [
      "insomnia"
      "docker"
      "raycast"
      "google-chrome"
      "firefox"
      "1password"
      "vlc"
      "gimp"
      "visual-studio-code"
      "nss"
    ];
    taps = [ ];
    brews = [ ];
  };
}
