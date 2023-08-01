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
      "microsoft-edge"
      "firefox"
      "1password"
      "1password-cli"
      "vlc"
      "gimp"
      "visual-studio-code"
      "swiftformat-for-xcode"
    ];
    taps = [ "leoafarias/fvm" ];
    brews = [ "nss" "fvm" "unar" ];
  };
}
