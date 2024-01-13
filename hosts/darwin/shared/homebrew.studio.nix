{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = { };
    casks = [
      "prismlauncher"
      "zulu17"
      "steam"
      "keymapp"
      "whatsapp"
      "sonos"
      "flutter"
    ];
    taps = [ "homebrew/cask-versions" ];
    brews = [
      #"podman"
    ];
  };
}
