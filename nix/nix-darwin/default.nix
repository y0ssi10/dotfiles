{ pkgs, ...}:
{
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      interval = {
        Hour = 9;
        Minute = 0;
      };
      options = "--delete-older-than 14d";
    };
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = 8;
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
    stateVersion = 5;
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
        NewWindowTarget = "PfHm";
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

    taps = [
      "homebrew/bundle"
    ];

    brews = [
      # Bourne-Again SHell, a UNIX command interpreter
      "bash"
      # Cryptography and SSL/TLS Toolkit
      "openssl@3"
      # Clone of cat(1) with syntax highlighting and Git integration
      "bat"
      # GNU internationalization (i18n) and localization (l10n) library
      "gettext"
      # GNU File, Shell, and Text utilities
      "coreutils"
      # Get a file from an HTTP, HTTPS or FTP server
      "curl"
      # File comparison utilities
      "diffutils"
      # Load/unload environment variables based on $PWD
      "direnv"
      # Bash, Zsh and Fish completion for Docker
      "docker-completion"
      # Pack, ship and run any application as a lightweight container
      "docker"
      # Modern, maintained replacement for ls
      "eza"
      # Like neofetch, but much faster because written mostly in C
      "fastfetch"
      # Simple, fast and user-friendly alternative to find
      "fd"
      # Collection of GNU find, xargs, and locate
      "findutils"
      # Command-line fuzzy finder written in Go
      "fzf"
      # GNU awk utility
      "gawk"
      # GitHub command-line tool
      "gh"
      # Remote repository management made easy
      "ghq"
      # Upload multiple artifacts to GitHub Release in parallel
      "ghr"
      # Distributed revision control system
      "git"
      # Prevents you from committing sensitive information to a git repo
      "git-secrets"
      # GNU implementation of the famous stream editor
      "gnu-sed"
      # GNU Transport Layer Security (TLS) Library
      "gnutls"
      # GNU Pretty Good Privacy (PGP) package
      "gnupg"
      # GNU grep, egrep and fgrep
      "grep"
      # Lightweight and flexible command-line JSON processor
      "jq"
      # Kubernetes CLI To Manage Your Clusters In Style!
      "k9s"
      # Easy way to access the system keyring service from python
      "keyring"
      # Run local Kubernetes cluster in Docker
      "kind"
      # Simple terminal UI for git commands
      "lazygit"
      # Polyglot runtime manager (asdf rust clone)
      "mise"
      # Interactive cheatsheet tool for the command-line
      "navi"
      # Ambitious Vim-fork focused on extensibility and agility
      "neovim"
      # Network Kanji code conversion Filter (NKF)
      "nkf"
      # Pinentry for GPG on Mac
      "pinentry-mac"
      # Search tool like grep and The Silver Searcher
      "ripgrep"
      # Fast, configurable, shell plugin manager
      "sheldon"
      # Static analysis and lint tool, for (ba)sh scripts
      "shellcheck"
      # Cross-shell prompt for astronauts
      "starship"
      # Terminal multiplexer
      "tmux"
      # Vi 'workalike' with many additional features
      "vim"
      # Tool for creating isolated virtual python environments
      "virtualenv"
      # Process YAML, JSON, XML, CSV and properties documents from the CLI
      "yq"
      # UNIX shell (command interpreter)
      "zsh"
    ];

    casks = [
      # GPU-accelerated terminal emulator
      "alacritty"
      # Chromium based browser
      "arc"
      # App for managing battery charging. (Also installs a CLI on first use.)
      "battery"
      # Tool to customise input devices and automate computer systems
      "bettertouchtool"
      # Write, edit, and chat about your code with AI
      "cursor"
      "font-udev-gothic-nf"
      # Web browser
      "google-chrome"
      # Japanese input software
      "google-japanese-ime"
      # Keymap tool for Happy Hacking Keyboard Professional (Hybrid models only)
      "hhkb-keymap-tool"
      # Software for Logitech devices
      "logi-options+"
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
