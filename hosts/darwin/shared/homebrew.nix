{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {
      Xcode = 497799835;
      UTM = 1538878817;
      TestFlight = 899247664;
      #"Microsoft Remote Desktop" = 1295203466;
      "Microsoft Word" = 462054704;
      "Microsoft Excel" = 462058435;
      "Microsoft Powerpoint" = 462062816;
      #"Microsoft Outlook" = 985367838;
      "Microsoft OneDrive" = 823766827;
      #"Microsoft ToDo" = 1274495053;
      # Slack = 803453959;
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
