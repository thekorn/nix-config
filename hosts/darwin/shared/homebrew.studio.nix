{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = { };
    casks = [
      "insomnia"
      "prismlauncher"
      "zulu17"
      "steam"
      "keymapp"
      "whatsapp"
      "sonos"
      "flutter"
      "arc"
      "zulip"
      "microsoft-edge"
    ];
    taps = [ "homebrew/cask-versions" ];
    brews = [
      #"podman"
    ];
  };
}
