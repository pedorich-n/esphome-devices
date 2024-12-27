{
  perSystem = { pkgs, config, ... }: {
    devShells = {
      default =
        let
          customPackages = [
            config.packages.run-with-secrets
            config.packages.esphome-with-secrets
          ];
        in
        pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            bashInteractive
            just
            python3
          ] ++ customPackages;

          inputsFrom = customPackages;

          # For some unknown reason, esphome CLI decides it's a good idea to write a .gitignore file in the device's config folder if one doesn't exist.
          # Thankfully it can be disabled with ESPHOME_NOGITIGNORE
          # See https://github.com/esphome/esphome/blob/387bde/esphome/writer.py#L210-L211
          shellHook = ''
            export ESPHOME_NOGITIGNORE=true

            python --version
            pio --version
            echo "ESPHome $(esphome version)"
          '';
        };
    };
  };
}
