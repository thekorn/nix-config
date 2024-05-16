{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = { };
    casks = [
      "docker"
      "flutter"
      "raycast"
      "google-chrome"
      "firefox"
      "1password"
      "vlc"
      "gimp"
      "visual-studio-code"
      "brave-browser"
      "bruno"
      "zed"
    ];
    taps = [ "leoafarias/fvm" ];
    brews = [
      "nss"
      "fvm"
      "unar"
      "aria2"
      "ktlint"
      "swiftformat"
      "clang-format"
      "cocoapods"
      "zig"
      "zls"
    ];
  };
}
