{
  perSystem =
    {
      pkgs,
      helpers,
      ...
    }:
    {
      packages = rec {
        run-with-secrets = pkgs.callPackage ../nix/packages/run-with-secrets.nix { inherit (helpers) esphome-secrets-hook; };
        esphome-with-secrets = pkgs.callPackage ../nix/packages/esphome-with-secrets.nix { inherit run-with-secrets; };
      };
    };
}
