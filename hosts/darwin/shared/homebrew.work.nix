{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = { };
    casks = [
      "zulu"
      "snowflake-snowsql"
      "vlc"
      "zeplin"
      "zulip"
      "microsoft-edge"
      "android-studio"
      "slack"
    ];
  };
}
