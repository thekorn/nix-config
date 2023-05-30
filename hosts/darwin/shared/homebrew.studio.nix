{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = { };
    casks = [ "prismlauncher" "zulu17" "steam" ];
    taps = [ "homebrew/cask-versions" ];
    brews = [ ];
  };
}
