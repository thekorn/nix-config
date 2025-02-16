{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation.cleanup = "zap";
    global.brewfile = true;
    masApps = {};
    casks = [
      "flutter"
      "raycast"
      "google-chrome"
      "firefox"
      "1password"
      "vlc"
      "gimp"
      "android-studio"
      "brave-browser"
      "bruno"
      "zed"
      #"tableplus"
      "ghostty"
    ];
    taps = ["leoafarias/fvm" "LucasPickering/homebrew-tap"];
    brews = [
      "nss"
      "fvm"
      "swiftformat" #<- nix version is outdated
      "cocoapods"
      "LucasPickering/homebrew-tap/slumber" #<- nix version is outdated
    ];
  };
}
