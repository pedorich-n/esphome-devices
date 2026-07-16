{
  writeShellApplication,
  gitMinimal,
  fd,
}:
writeShellApplication {
  name = "run-with-secrets";
  runtimeInputs = [
    gitMinimal
    fd
  ];

  # op binary must be provided by the host system
  text = ''
    ROOT="$(git rev-parse --show-toplevel)"
    export ROOT
    RUNTIME_SECRETS="''${ROOT}/devices/common/secrets.yaml"

    if ! [ -x "$(command -v op)" ]; then
      echo "Error: 1Password CLI (op) not found in PATH!" >&2
      exit 1
    fi

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
