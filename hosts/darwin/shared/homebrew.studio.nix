{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = [
      "prismlauncher"
      "zulu@17"
      "zulu@21"
      "steam"
      "keymapp"
      #"whatsapp"
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
