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
      "vlc"
      "gimp"
      "visual-studio-code"
      "brave-browser"
      "bruno"
      "cleanshot"
    ];
    taps = [ "leoafarias/fvm" ];
    brews =
      [ "nss" "fvm" "unar" "aria2" "ktlint" "swiftformat" "clang-format" ];
  };
}
