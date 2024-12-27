{ pkgs, ... }:
pkgs.writeShellApplication {
  name = "run-with-secrets";
  runtimeInputs = [
    pkgs.gitMinimal
    pkgs.fd
  ];

  # op binary must be provided by the host system
  text = ''
    ROOT="$(git rev-parse --show-toplevel)"
    export ROOT
    RUNTIME_SECRETS="''${ROOT}/devices/common/secrets.yaml"

    function cleanup() {
      if [ -f "''${RUNTIME_SECRETS}" ]; then
        rm "''${RUNTIME_SECRETS}"
      fi
    }

    trap cleanup EXIT

    op inject --in-file "''${ROOT}/devices/common/op_secrets.yaml" --out-file "''${RUNTIME_SECRETS}" --force

    readarray -t devices < <(fd --type=dir --max-depth=1 --exclude=common --format "{/}" . "''${ROOT}/devices")

    for device in "''${devices[@]}"; do
      ln --symbolic --force "''${RUNTIME_SECRETS}" "''${ROOT}/devices/''${device}/secrets.yaml"
    done

    "$@"
  '';
}
