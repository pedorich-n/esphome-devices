{
  perSystem =
    { pkgs, ... }:
    {
      packages = rec {
        run-with-secrets = pkgs.callPackage ../pkgs/run-with-secrets { };

        esphome-with-secrets = pkgs.callPackage ../pkgs/esphome-with-secrets { inherit run-with-secrets; };
      };
    };
}
