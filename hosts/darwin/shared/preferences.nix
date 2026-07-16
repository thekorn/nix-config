{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.preferences;
in {
  imports = [
    ../../shared/certificates.nix
  ];

  options.custom.preferences = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "Username of the primary macOS user.";
    };

    blockAllIncoming = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether the macOS application firewall blocks all incoming connections.";
    };
  };

  config = {
    # https://github.com/nix-darwin/nix-darwin/issues/1457
    system.primaryUser = cfg.username;
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
          "${pkgs.zed-editor}/Applications/Zed.app" # nixpkgs version
          #"/Applications/Zed.app" #homebrew version
          "/System/Applications/Notes.app"
          "/Applications/Safari.app"
          "${pkgs.ghostty-bin}/Applications/Ghostty.app"
        ];
        persistent-others = [
          "/tmp/"
          "/Users/${cfg.username}/Downloads/"
        ];
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

      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
    };

    networking = {
      applicationFirewall = {
        enableStealthMode = true;
        allowSignedApp = true;
        allowSigned = true;
        enable = true;
        blockAllIncoming = cfg.blockAllIncoming;
      };
      wakeOnLan = {
        enable = true;
      };
    };

    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
}
