{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    casks = [
      "obs"
      "steam"
      "prismlauncher"
      #"zen"
      "nvidia-geforce-now"
      #"vibetunnel"
    ];
    brews = [
    ];
  };
}
