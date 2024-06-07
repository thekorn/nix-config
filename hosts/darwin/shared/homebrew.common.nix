{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation.cleanup = "zap";
    global.brewfile = true;
    masApps = {};
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
      "android-studio"
      "brave-browser"
      "bruno"
      "zed"
      "zulu"
    ];
    taps = ["leoafarias/fvm"];
    brews = [
      "nss"
      "fvm"
      "swiftformat" #<- nix version is outdated
      "cocoapods"
      # workaround, zig nix is broken https://github.com/NixOS/nixpkgs/issues/317055
      "zig"
      "zls"
    ];
  };
}
