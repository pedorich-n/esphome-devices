{
  perSystem =
    {
      pkgs,
      config,
      helpers,
      lib,
      ...
    }:

    {
      devShells = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = lib.callPackageWith (
          pkgs
          // {
            inherit (config.packages) run-with-secrets esphome-with-secrets;
            inherit (helpers) esphome-secrets-hook;
          }
        );
        directory = ../nix/shells;
      };
    };
}
