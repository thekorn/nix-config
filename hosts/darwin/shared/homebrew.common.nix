{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation.cleanup = "zap";
    global.brewfile = true;
    masApps = {};
    casks = [
      "1password" #<- nix version is marked as broken
      "android-studio"
      "ghostty" #<- nix version is marked as broken
      "firefox" #<- nix version is broken
      "docker-desktop" #<-- podman does not work for CTF
    ];
    taps = ["leoafarias/fvm" "sst/tap"];
    brews = [
      "fvm"
      "opencode"
      "gemini-cli" #<-- nix version is outdated
    ];
  };
}
