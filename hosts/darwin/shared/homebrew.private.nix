{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {
      UTM = 1538878817;
      "Microsoft Remote Desktop" = 1295203466;
      "Microsoft OneDrive" = 823766827;
    };
    casks = [ "docker" "insomnia" ];
    taps = [ ];
    # brews = [ "qmk/qmk/qmk" ];
  };
}
