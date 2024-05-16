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
      "arc"
      "zulip"
      "microsoft-edge"
    ];
    taps = [ "homebrew/cask-versions" ];
    brews = [
      #"podman"
      "wb32-dfu-updater_cli"
    ];
  };
}
