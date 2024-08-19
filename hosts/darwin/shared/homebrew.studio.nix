{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = [
      "prismlauncher"
      "zulu@17"
      "steam"
      "keymapp"
      "whatsapp"
      "sonos"
      "arc"
      "zulip"
      "whatsapp"
      "chatgpt"
      "proxyman"
    ];
    taps = ["homebrew/cask-versions"];
    brews = [
      #"podman"
      "wb32-dfu-updater_cli"
    ];
  };
}
