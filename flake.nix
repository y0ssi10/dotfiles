{
  description = "My package definition";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
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
    }@inputs:
    let
      system = "aarch64-darwin";
      defaultUsername = "y0ssi10";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      apps.${system} = {
        update = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "update-script" ''
              set -e

              USERNAME="''${1:-${defaultUsername}}"
              echo "Using username: $USERNAME"

              echo "Updating flake..."
              nix flake update
              echo "Updating home-manager..."
              nix run nixpkgs#home-manager -- switch --flake .#myHomeConfig --arg username "$USERNAME"
              echo "Updating nix-darwin..."
              nix run nix-darwin -- switch --flake .#y0ssi10-darwin
              echo "Update complete!"
            ''
          );
        };

        update-home = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "update-script" ''
              set -e

              USERNAME="''${1:-${defaultUsername}}"
              echo "Using username: $USERNAME"

              echo "Updating flake..."
              nix flake update
              echo "Updating home-manager..."
              nix run nixpkgs#home-manager -- switch --flake .#myHomeConfig --arg username "$USERNAME"
              echo "Update complete!"
            ''
          );
        };
        update-darwin = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "update-script" ''
              set -e
              echo "Updating flake..."
              nix flake update
              echo "Updating nix-darwin..."
              nix run nix-darwin -- switch --flake .#y0ssi10-darwin
              echo "Update complete!"
            ''
          );
        };
      };

      darwinConfigurations.y0ssi10-darwin = nix-darwin.lib.darwinSystem {
        system = system;
        modules = [ ./nix/nix-darwin/default.nix ];
      };

      homeConfigurations = {
        myHomeConfig = { username ? defaultUsername }: home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            inherit inputs username;
          };
          modules = [ ./nix/home-manager/default.nix ];
        };
      };
    };
}
