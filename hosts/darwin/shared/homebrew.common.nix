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
      "brave-browser"
    ];
    taps = [ "leoafarias/fvm" ];
    brews = [
      "zig"
      "swift-format"
      "nss"
      "fvm"
      "unar"
      "xcodesorg/made/xcodes"
      "aria2"
      "hyperfine"
    ];
  };
}
