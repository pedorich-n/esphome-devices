{
  inputs,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.partitions
  ];

  partitions.dev = {
    extraInputsFlake = ../dev;
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
