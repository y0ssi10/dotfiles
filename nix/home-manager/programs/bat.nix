# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable
{
  pkgs,
  ...
}:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "Solarized (light)";
      map-syntax = [
        ".ignore:Git Ignore"
      ];
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batgrep
      batman
      batpipe
      batwatch
      prettybat
    ];
  };
}
