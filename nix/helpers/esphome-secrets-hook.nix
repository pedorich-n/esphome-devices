{
  writeTextFile,
  gitMinimal,
  fd,
  shellcheck-minimal,
  lib,
}:
writeTextFile {
  name = "esphome-secrets-hook";
  executable = false;
  # $target is defined in writeTextFile's buildPhase
  checkPhase = ''
    ${lib.getExe shellcheck-minimal} --shell bash "$target"
  '';
  text = ''
    [ -n "''${ESPHOME_SECRETS_INJECTED:-}" ] && return 0

    if ! command -v op >/dev/null; then
    	echo "warning: 'op' (1Password CLI) not found in PATH — secret injection not available" >&2
    	return 0
    fi

    ROOT="$(${lib.getExe gitMinimal} rev-parse --show-toplevel)"
    RUNTIME_SECRETS="''${ROOT}/devices/common/secrets.yaml"
    ESPHOME_SYMLINKS=()

    esphome_secrets_cleanup() {
    	if [ -f "''${RUNTIME_SECRETS}" ]; then
    		rm "''${RUNTIME_SECRETS}"
    	fi
    	for symlink in "''${ESPHOME_SYMLINKS[@]}"; do
    		if [ -L "''${symlink}" ]; then
    			rm "''${symlink}"
    		fi
    	done
    }

    trap esphome_secrets_cleanup EXIT

    if op inject --in-file "''${ROOT}/devices/common/op_secrets.yaml" --out-file "''${RUNTIME_SECRETS}" --force; then
    	readarray -t devices < <(${lib.getExe fd} --type=dir --max-depth=1 --exclude=common --format '{/}' . "''${ROOT}/devices")
    	for device in "''${devices[@]}"; do
    		ln --symbolic --force "''${RUNTIME_SECRETS}" "''${ROOT}/devices/''${device}/secrets.yaml"
    		ESPHOME_SYMLINKS+=("''${ROOT}/devices/''${device}/secrets.yaml")
    	done
    	export ESPHOME_SECRETS_INJECTED=1
    else
    	echo "warning: 'op inject' failed — secrets not available" >&2
    fi
  '';
}
