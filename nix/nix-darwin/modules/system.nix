{
  system = {
    stateVersion = 6;
    primaryUser = "y0ssi10";
    defaults = {
      NSGlobalDomain = {
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.sound.beep.volume" = 0.000;
        "com.apple.trackpad.scaling" = 3.0;
        # Enable showing all extensions for Finder
        AppleShowAllExtensions = true;
        # Enable showing all files for Finder
        AppleShowAllFiles = true;
        # Enable showing keyboard UI mode for Finder
        AppleKeyboardUIMode = 3;
        # Set initial key repeat to 12
        InitialKeyRepeat = 12;
        # Set key repeat to 1
        KeyRepeat = 1;
        # Disable press and hold for all keys
        ApplePressAndHoldEnabled = false;
        # Enable mouse swipe navigate with scrolls
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        AppleInterfaceStyle = "Dark";
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
      };
      controlcenter = {
        # Enable Bluetooth
        Bluetooth = true;
        # Disable AirDrop
        AirDrop = false;
      };
      finder = {
        # Enable showing all files for Finder
        AppleShowAllFiles = true;
        # Enable showing all extensions for Finder
        AppleShowAllExtensions = true;
        # Disable creating desktop for Finder
        CreateDesktop = false;
        # Disable warning when changing extension for Finder
        FXEnableExtensionChangeWarning = false;
        # Set preferred view style for Finder to Nlsv
        FXPreferredViewStyle = "Nlsv";
        # Enable showing path bar for Finder
        ShowPathbar = true;
        # Set new window target to Home for Finder
        NewWindowTarget = "Home";
      };
      dock = {
        # Set Dock orientation to right
        orientation = "right";
        # Enable autohide for Dock
        autohide = true;
        # Set Dock tile size to 50
        tilesize = 50;
        # Disable magnification for Dock
        magnification = false;
        # Disable showing recent items for Dock
        show-recents = false;
        # Set Dock bottom right corner to Desktop
        wvous-br-corner = 4;
        # Disable automatically rearranging spaces
        mru-spaces = false;
        # Enable static only for Dock
        static-only = true;
      };
      menuExtraClock = {
        # Enable showing 24 hour time for menubar
        Show24Hour = true;
        # Enable showing date in menubar
        ShowDate = 0;
        # Enable showing day of month for menubar
        ShowDayOfMonth = true;
        # Enable showing day of week for menubar
        ShowDayOfWeek = true;
        # Disable showing seconds for menubar
        ShowSeconds = false;
      };
      screencapture = {
        # Set target to clipboard
        target = "clipboard";
      };
      spaces = {
        # Disable spanning displays for spaces
        spans-displays = false;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      # Map Caps Lock to Control
      remapCapsLockToControl = true;
    };
  };
}