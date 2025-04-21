{ withSystem, inputs, ... }:
{
  perSystem = { system, ... }: {
    _module.args = {
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          (_: prev: {
            # https://nixos.org/manual/nixpkgs/stable/#how-to-override-a-python-package-for-all-python-versions-using-extensions
            pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
              (python-final: python-prev: {
                # Required until https://github.com/esphome/esphome/pull/6662 is merged
                paho-mqtt = python-final.callPackage ../pkgs/paho-mqtt-1 { };
              })
            ];

            esphome = prev.esphome.overridePythonAttrs (old: {
              disabledTests = old.disabledTests ++ [
                "test_write_utf8_file" # Fails with `Failed: DID NOT RAISE <class 'OSError'>`
              ];
            });
          })
        ];
      };
    };
  };

  flake = {
    the_pkgs = withSystem "x86_64-linux" ({ pkgs, ... }: pkgs);
  };
}
