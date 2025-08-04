{ inputs, lib, config, pkgs, ... }:
  let
    username = "y0ssi10";
  in
  {
    home = {
      username = username;
      homeDirectory = "/Users/${username}";

      stateVersion = "24.11";
      packages = with pkgs; [
        nix-zsh-completions
        starship
        lazygit
        vim
      ];
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

    imports = [
      ./programs/bat.nix
      ./programs/direnv.nix
      ./programs/eza.nix
    ];

    # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fastfetch.enable
    programs.fastfetch.enable = true;

}
