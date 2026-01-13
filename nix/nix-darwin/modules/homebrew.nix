{
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
      "alacritty"
      # Chromium based browser
      "arc"
      # App for managing battery charging. (Also installs a CLI on first use.)
      "battery"
      # Desktop password and login vault
      "bitwarden"
      # Write, edit, and chat about your code with AI
      "cursor"
      # Dia browser
      "thebrowsercompany-dia"
      "font-udev-gothic-nf"
      # Terminal emulator that uses platform-native UI and GPU acceleration
      "ghostty"
      # Web browser
      "google-chrome"
      # Japanese input software
      "google-japanese-ime"
      # Software for Logitech devices
      "logi-options+"
      # Knowledge base that works on top of a local folder of plain text Markdown files
      "obsidian"
      # Replacement for Docker Desktop
      "orbstack"
      # Collaboration platform for API development
      "postman"
      # Control your tools with a few keystrokes
      "raycast"
      # Open-source code editor
      "visual-studio-code"
    ];
  };
}
