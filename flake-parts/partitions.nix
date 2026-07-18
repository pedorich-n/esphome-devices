{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.partitions
  ];

  partitions.dev = {
    extraInputsFlake = ../dev;
    extraInputs = {
      nixpkgs = lib.mkForce inputs.nixpkgs;
    };
    module = {
      imports = [
        ../dev/flake-module.nix
      ];

      perSystem = {
        treefmt.config = {
          projectRoot = ../.;
        };
      };
    };
  };

  partitionedAttrs = {
    devShells = "dev";
    checks = "dev";
    formatter = "dev";
  };
}
