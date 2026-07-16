{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages = rec {
        run-with-secrets = pkgs.callPackage ../nix/packages/run-with-secrets.nix { };
        esphome-with-secrets = pkgs.callPackage ../nix/packages/esphome-with-secrets.nix { inherit run-with-secrets; };
      };
    };
}
