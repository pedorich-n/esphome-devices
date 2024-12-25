{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = inputs@{ flake-parts, systems, self, ... }: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;
    imports = [ inputs.treefmt-nix.flakeModule ];

    perSystem = { system, pkgs, lib, ... }: {
      devShells = {
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            bashInteractive
            git
            just
            python3

            esphome
            platformio-core
            platformio
          ];

          shellHook = ''
            export INSIDE_NIX_DEVELOP=true
            export ESPHOME_NOGITIGNORE=true

            ${lib.getExe pkgs.python3} --version
            ${lib.getExe pkgs.platformio-core} --version
            echo "ESPHome $(${lib.getExe pkgs.esphome} version)"
          '';
        };
      };

      treefmt = {
        projectRootFile = ".root";
        flakeCheck = true;

        settings.formatter = {
          just = {
            command = pkgs.just;
            options = [
              "--fmt"
              "--unstable"
              "--justfile"
            ];
            includes = [ "justfile" ];
          };
        };

        programs = {
          # Nix
          nixpkgs-fmt.enable = true;

          # YAML, etc
          prettier.enable = true;
        };
      };
    };
  };
}

