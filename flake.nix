{
  description = "y0ssi10's dotfiles";

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
      pkgs = import nixpkgs { inherit system; };
    in
    {
      apps.${system} = {
        update = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "update-script" ''
              set -e

              echo "Updating flake..."
              nix flake update
              echo "Updating home-manager..."
              nix run nixpkgs#home-manager -- switch --flake .#y0ssi10-home
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

              echo "Updating flake..."
              nix flake update
              echo "Updating home-manager..."
              nix run nixpkgs#home-manager -- switch --flake .#y0ssi10-home
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

      darwinConfigurations = {
        y0ssi10-darwin = nix-darwin.lib.darwinSystem {
          system = system;
          specialArgs = {
            username = "y0ssi10";
          };
          modules = [ ./nix/nix-darwin/default.nix ];
        };

        runner-darwin = nix-darwin.lib.darwinSystem {
          system = system;
          specialArgs = {
            username = "runner";
          };
          modules = [ ./nix/nix-darwin/default.nix ];
        };

      };

      homeConfigurations = {
        y0ssi10-home = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            username = "y0ssi10";
            inherit inputs;
          };
          modules = [ ./nix/home-manager/default.nix ];
        };
        runner-home = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            username = "runner";
            inherit inputs;
          };
          modules = [ ./nix/home-manager/default.nix ];
        };
      };
    };
}
