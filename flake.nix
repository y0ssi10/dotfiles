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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      treefmt-nix,
      ...
    }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      mkHomeConfig =
        username:
        import ./nix/home-manager {
          inherit
            system
            home-manager
            pkgs
            username
            ;
        };
      mkDarwinConfig =
        username:
        import ./nix/nix-darwin {
          inherit system nix-darwin username;
        };
      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
        };
      };
    in
    {
      apps = (
        import ./nix/apps {
          inherit nixpkgs;
        }
      );

      darwinConfigurations = (mkDarwinConfig "y0ssi10") // {
        runner = (mkDarwinConfig "runner").default;
      };

      homeConfigurations = (mkHomeConfig "y0ssi10") // {
        runner = (mkHomeConfig "runner").default;
      };

      formatter.${system} = treefmtEval.config.build.wrapper;

      checks.${system}.formatting = treefmtEval.config.build.check self;
    };
}
