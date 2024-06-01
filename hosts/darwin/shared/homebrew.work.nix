{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = ["snowflake-snowsql" "vlc" "zeplin" "zulip" "microsoft-edge" "slack"];
  };
}
