{
  username,
  pkgs,
  ...
}: {
  imports = [
    ../../shared/certificates.nix
  ];

  # https://github.com/nix-darwin/nix-darwin/issues/1457
  system.primaryUser = username;
  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      minimize-to-application = false;
      expose-group-apps = true;
      tilesize = 36;
      orientation = "bottom";
      show-recents = false;
      persistent-apps = [
        "/System/Applications/Mail.app"
        "${pkgs.zed-editor}/Applications/Zed.app"
        "/System/Applications/Notes.app"
        "/Applications/Safari.app"
        "/Applications/Ghostty.app"
      ];
      persistent-others = ["/tmp/" "/Users/${username}/Downloads/"];
    };

    screencapture.location = "/tmp";

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
      TrackpadRightClick = true;
    };

    NSGlobalDomain = {
      AppleFontSmoothing = 1;
      ApplePressAndHoldEnabled = true;
      AppleKeyboardUIMode = 3;
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      AppleShowScrollBars = "Automatic";
      AppleShowAllExtensions = true;
      AppleTemperatureUnit = "Celsius";
      # InitialKeyRepeat                     = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      # auto hide menu bar on top
      _HIHideMenuBar = false;
    };

    alf = {
      globalstate = 1;
      allowsignedenabled = 1;
      allowdownloadsignedenabled = 1;
      stealthenabled = 1;
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  security.pki.certificateFiles = [
    ../../shared/fritz.box.pem
  ];
}
