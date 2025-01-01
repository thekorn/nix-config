{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = [
      "prismlauncher"
      "zulu"
      "zulu@17"
      "zulu@21"
      "steam"
      "keymapp"
      "chatgpt"
      "proxyman"
      "raspberry-pi-imager"
      "obs"
    ];
    brews = [
      #"podman"
      "wb32-dfu-updater_cli"
    ];
  };
}
