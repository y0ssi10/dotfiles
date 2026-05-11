{
  system,
  nix-darwin,
  username,
}:
{
  default = nix-darwin.lib.darwinSystem {
    inherit system;
    modules = [
      ./modules/nix.nix
      (import ./modules/system.nix { inherit username; })
      ./modules/homebrew.nix
    ];
  };
}
