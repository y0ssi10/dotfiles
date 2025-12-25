{
  pkgs,
  lib,
  ...
}:
{
  nix = {
    enable = false;
    settings = {
      experimental-features = "nix-command flakes";
      use-xdg-base-directories = true;
      max-jobs = 8;
      trusted-users = [
        "root"
        "@wheel"
      ]
      ++ lib.optional pkgs.stdenv.isDarwin "@admin";
    };
    optimise.automatic = false;
    gc = {
      automatic = false;
      interval = {
        Weekday = 7;
        Hour = 12;
        Minute = 0;
      };
      options = "--delete-older-than 14d";
    };
  };
}