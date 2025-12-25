{
  description = "y0ssi10's Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      system = "aarch64-darwin";
    in
    {
      apps = (
        import ./nix/apps {
          inherit nixpkgs;
        }
      );

      darwinConfigurations = (
        import ./nix/nix-darwin {
          inherit system nix-darwin;
        }
      );

      homeConfigurations = (
        import ./nix/home-manager {
          inherit system home-manager;
          username = "y0ssi10";
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        }
      );
    };
}