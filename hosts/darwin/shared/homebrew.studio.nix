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
      "zulip"
      "whatsapp"
      "chatgpt"
      "proxyman"
    ];
    brews = [
      #"podman"
      "wb32-dfu-updater_cli"
    ];
  };
}
