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
      "microsoft-edge"
      "whatsapp"
      "chatgpt"
      "proxyman"
    ];
    taps = ["homebrew/cask-versions" "LucasPickering/homebrew-tap"];
    brews = [
      #"podman"
      "wb32-dfu-updater_cli"
      "LucasPickering/homebrew-tap/slumber"
    ];
  };
}
