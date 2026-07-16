{
  run-with-secrets,
  esphome-with-secrets,
  esphome-secrets-hook,
  mkShell,
  bashInteractive,
  python3,
}:
mkShell {
  nativeBuildInputs = [
    bashInteractive
    python3
    run-with-secrets
    esphome-with-secrets
  ];

  inputsFrom = [
    run-with-secrets
    esphome-with-secrets
    esphome-secrets-hook
  ];

  # For some unknown reason, esphome CLI decides it's a good idea to write a .gitignore file in the device's config folder if one doesn't exist.
  # Thankfully it can be disabled with ESPHOME_NOGITIGNORE
  # See https://github.com/esphome/esphome/blob/387bde/esphome/writer.py#L210-L211
  shellHook = ''
    export ESPHOME_NOGITIGNORE=true

    # shellcheck source=/dev/null
    source ${esphome-secrets-hook}

    python --version
    pio --version
    echo "ESPHome $(esphome version)"
  '';
}
