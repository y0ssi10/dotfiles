{
  inputs,
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.11";
    packages = with pkgs; [
      bash
      # bat
      gettext
      coreutils
      curl
      diffutils
      # direnv
      # docker-completion
      # docker
      # eza
      # fastfetch
      fd
      findutils
      # fzf
      gawk
      # gh
      ghq
      # ghr
      git
      # git-secrets
      gnused
      gnupg
      gnugrep
      jq
      k9s
      kubectl
      # keyring
      kind
      # lazygit
      # mise
      # navi
      # neovim
      # nkf
      # ripgrep
      sheldon
      shellcheck
      starship
      tmux
      # vim
      zsh
      yq
      nix-zsh-completions
      lazydocker
    ];
  };

  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
    cacheHome  = "${config.home.homeDirectory}/.cache";
    dataHome   = "${config.home.homeDirectory}/.local/share";
    stateHome  = "${config.home.homeDirectory}/.local/state";
  };

  programs.home-manager.enable = true;
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        open = "repo view --web";
        create-pr = "pr create --assignee @me --fill --web";
      };
    };
    extensions = with pkgs; [
      gh-copilot
      gh-dash
      gh-markdown-preview
      gh-notify
    ];
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.alacritty.enable
  # programs.alacritty.enable = true;
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batgrep
      batman
      batpipe
      batwatch
      prettybat
    ];
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable
  programs.direnv = {
    enable = true;
    # config = {
    #   disable_stdin = true;
    #   strict_env = true;
    #   warn_timeout = 0;
    # };
    # nix-direnv.enable = true;
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enable
  programs.eza = {
    enable = true;
    colors = "auto";
    git = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
    ];
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fastfetch.enable
  programs.fastfetch.enable = true;
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fd.enable
  programs.fd.enable = true;
  programs.fzf.enable = true;
  # programs.ghostty.enable = true;
  programs.lazygit.enable = true;
  programs.mise.enable = true;
  programs.navi.enable = true;
  programs.neovim.enable = true;
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--hidden"
      "--smart-case"

      "--glob=!.git/"
    ];
  };
  # programs.tmux.enable = true;
  programs.vim.enable = true;
  # programs.zsh.enable = true;
}
