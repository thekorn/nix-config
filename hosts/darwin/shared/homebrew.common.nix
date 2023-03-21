{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = { };
    casks = [ "raycast" "google-chrome" "firefox" "1password" "vlc" "gimp" ];
    taps = [ ];
    brews = [ ];
  };
}
