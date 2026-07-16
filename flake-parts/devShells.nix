{
  perSystem =
    {
      pkgs,
      config,
      lib,
      ...
    }:

    {
      devShells = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = lib.callPackageWith (pkgs // { inherit (config.packages) run-with-secrets esphome-with-secrets; });
        directory = ../nix/shells;
      };
    };
}
