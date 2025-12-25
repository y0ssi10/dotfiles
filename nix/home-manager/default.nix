{
  system,
  username,
  home-manager,
  pkgs,
}:
let
  homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "/Users/${username}"
    else
      throw "Unsupported system: ${system}";
in
{
  default = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      {
        home = {
          inherit username;
          homeDirectory = homeDirectory;
          stateVersion = "25.11";
        };
        programs.home-manager.enable = true;
      }
      {
        home.packages = with pkgs; [
          bash
          bat
          coreutils
          curl
          diffutils
          direnv
          docker
          eza
          fastfetch
          fd
          findutils
          fzf
          gawk
          gettext
          gh
          ghq
          git
          gnused
          gnupg
          gnugrep
          jq
          k9s
          kubectl
          kind
          lazygit
          mise
          navi
          neovim
          nkf
          ripgrep
          lazydocker
          nix-zsh-completions
          ripgrep
          sheldon
          shellcheck
          starship
          tmux
          vim
          yq
        ];
      }
      {
        home.file.".zshenv".text = ''
          # Set ZDOTDIR before loading the actual .zshenv
          export XDG_CONFIG_HOME="${homeDirectory}/.config"
          export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
          
          # Source the actual .zshenv from ZDOTDIR
          if [[ -f "$ZDOTDIR/.zshenv" ]]; then
            source "$ZDOTDIR/.zshenv"
          fi
        '';
      }
      {
        xdg = {
          enable = true;
          configHome = "${homeDirectory}/.config";
          cacheHome  = "${homeDirectory}/.cache";
          dataHome   = "${homeDirectory}/.local/share";
          stateHome  = "${homeDirectory}/.local/state";
          configFile = {
            "alacritty/alacritty.toml".source = ./../../.config/alacritty/alacritty.toml;
            "bat/config".source = ./../../.config/bat/config;
            "direnv/direnv.toml".source = ./../../.config/direnv/direnv.toml;
            "gh/config.yml".source = ./../../.config/gh/config.yml;
            "git/config".source = ./../../.config/git/config;
            "git/ignore".source = ./../../.config/git/ignore;
            "gnupg/gpg-agent.conf".source = ./../../.config/gnupg/gpg-agent.conf;
            "lazygit/config.yml".source = ./../../.config/lazygit/config.yml;
            "mise/config.toml".source = ./../../.config/mise/config.toml;
            "navi/config.yaml".source = ./../../.config/navi/config.yaml;
            "navi/snippets".source = ./../../.config/navi/snippets;
            "navi/snippets".recursive = true;
            "npm/npmrc".source = ./../../.config/npm/npmrc;
            "python/startup.py".source = ./../../.config/python/startup.py;
            "scripts".source = ./../../.config/scripts;
            "scripts".recursive = true;
            "starship.toml".source = ./../../.config/starship/starship.toml;
            "tmux".source = ./../../.config/tmux;
            "tmux".recursive = true;
            "zsh/.zshrc".source = ./../../.config/zsh/.zshrc;
            "zsh/.zshenv".source = ./../../.config/zsh/.zshenv;
            "zsh/.zprofile".source = ./../../.config/zsh/.zprofile;
            "zsh/lazy.zsh".source = ./../../.config/zsh/lazy.zsh;
            "zsh/plugins.toml".source = ./../../.config/zsh/plugins.toml;
          };
        };
      }
    ];
  };
}