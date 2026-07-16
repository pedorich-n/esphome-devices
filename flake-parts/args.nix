{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      _module.args.helpers = {
        esphome-secrets-hook = pkgs.callPackage ../nix/helpers/esphome-secrets-hook.nix { };
      };
    };
}
