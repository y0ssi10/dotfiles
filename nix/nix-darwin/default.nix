{
  lib,
  pkgs,
  username,
  ...
}:
{
  nix = {
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = 8;
      trusted-users = ["root" "admin"];
    };
  };

  fonts = {
    packages = with pkgs; [
      hackgen-nf-font
      moralerspace-hwnf
      moralerspace-nf
      nerd-fonts.departure-mono
      nerd-fonts.symbols-only
      noto-fonts-color-emoji
      scientifica
      twitter-color-emoji
      udev-gothic-nf
    ];
  };

  system = {
    stateVersion = 6;
    primaryUser = if builtins.getEnv "USER" == "runner" then builtins.getEnv "USER" else "admin";
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        AppleKeyboardUIMode = 3;
        InitialKeyRepeat = 10;
        KeyRepeat = 1;
      };

      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        ShowPathbar = true;
        # Set default path for new windows.
        # Computer     : `PfCm`
        # Volume       : `PfVo`
        # $HOME        : `PfHm`
        # Desktop      : `PfDe`
        # Documents    : `PfDo`
        # All My Files : `PfAF`
        # Other…       : `PfLo`
        NewWindowTarget = "Home";
      };

      dock = {
        orientation = "right";
        autohide = true;
        tilesize = 50;
        magnification = false;
        show-recents = false;
        wvous-br-corner = 4;
        mru-spaces = false;
      };
    };

    keyboard = {
      enableKeyMapping = true;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
    };

    brews = [
      # Pinentry for GPG on Mac
      "pinentry-mac"
    ];

    casks = [
      # GPU-accelerated terminal emulator
      "ghostty"
      "alacritty"
      # Chromium based browser
      # "arc"
      # Write, edit, and chat about your code with AI
      "cursor"
      # "font-udev-gothic-nf"
      # Web browser
      # "google-chrome"
      # Japanese input software
      # "google-japanese-ime"
      # Replacement for Docker Desktop
      # "orbstack"
      # Collaboration platform for API development
      "postman"
      # Control your tools with a few keystrokes
      "raycast"
      # Open-source code editor
      # "visual-studio-code"
    ];
  };
}
