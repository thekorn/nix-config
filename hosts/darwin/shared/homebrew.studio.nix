{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = { };
    casks = [ "prismlauncher" "zulu17" ];
    taps = [ "homebrew/cask-versions" ];
    brews = [ ];
  };
}
