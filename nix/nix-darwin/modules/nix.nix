{
  pkgs,
  lib,
  ...
}:
{
  nix = {
    # Nix is installed and its daemon/nix.conf is managed by the Determinate Nix
    # installer, not nix-darwin. Keep this disabled to avoid the two fighting
    # over /etc/nix/nix.conf.
    enable = false;

    # NOTE: `nix.settings.*` below has NO EFFECT while `nix.enable = false` —
    # nix-darwin skips managing /etc/nix/nix.conf entirely in that case (see
    # `handleUnmanaged` in nix-darwin's modules/nix/default.nix). The values
    # here are kept only as a record of intent; equivalent config today lives
    # in Determinate's own nix.conf, with user overrides going in
    # /etc/nix/nix.custom.conf (not managed by this repo). Uncomment only if
    # `nix.enable` is switched back to `true`.
    # settings = {
    #   experimental-features = "nix-command flakes";
    #   use-xdg-base-directories = true;
    #   max-jobs = 8;
    #   trusted-users = [
    #     "root"
    #     "@wheel"
    #   ]
    #   ++ lib.optional pkgs.stdenv.isDarwin "@admin";
    # };

    # These two ARE live options (defined in separate nix-darwin modules, not
    # gated by nix.enable) — but both are off here. If `automatic` is ever
    # flipped to `true` while `nix.enable` stays `false`, the build fails with
    # an assertion (`nix.gc.automatic requires nix.enable`), so this can't
    # silently do nothing.
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
