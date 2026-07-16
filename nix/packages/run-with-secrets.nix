{
  writeShellApplication,
  esphome-secrets-hook,
}:
writeShellApplication {
  name = "run-with-secrets";

  text = ''
    # shellcheck source=/dev/null
    source ${esphome-secrets-hook}

    if [ -z "''${ESPHOME_SECRETS_INJECTED:-}" ]; then
      echo "error: secret injection failed — 'op' not found or 'op inject' failed" >&2
      exit 1
    fi

    "$@"
  '';
}
