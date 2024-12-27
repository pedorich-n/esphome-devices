{ pkgs, run-with-secrets, ... }:
let
  coreDependencies = with pkgs; [
    esphome
    platformio
    platformio-core
  ];
in
pkgs.writeShellApplication {
  name = "esphome-with-secrets";
  runtimeInputs = coreDependencies ++ [
    pkgs.gitMinimal

    run-with-secrets
  ];

  derivationArgs = {
    propagatedNativeBuildInputs = coreDependencies;
  };

  # For some unknown reason, esphome CLI decides it's a good idea to write a .gitignore file in the device's config folder if one doesn't exist.
  # Thankfully it can be disabled with ESPHOME_NOGITIGNORE
  # See https://github.com/esphome/esphome/blob/387bde/esphome/writer.py#L210-L211
  text = ''
    export ESPHOME_NOGITIGNORE=true  
    GIT_REV=$(git describe --tags --always --dirty)
    ESPHOME_BASE="esphome --substitution git_rev ''${GIT_REV}"

    # shellcheck disable=SC2068,SC2086
    run-with-secrets ''${ESPHOME_BASE} $@
  '';
}
