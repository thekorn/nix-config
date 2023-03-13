{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {
      # Xcode = 497799835;
    };
    casks = [
      "raycast"
      "docker"
      "google-chrome"
      "firefox"
      "flutter"
      "android-studio"
      "zulu"
      "1password"
      "insomnia"
      "snowflake-snowsql"
      "vlc"
    ];
    taps = [ ];
    brews = [ ];
  };
}
