import "dev/justfile.default"

compile config *args:
    just _run esphome-with-secrets compile {{config}} {{args}}

flash config *args:
    just _run esphome-with-secrets run {{config}} {{args}}

logs config *args:
    just _run esphome-with-secrets logs {{config}} {{args}}

shell *args:
    just _develop "{{ args }}"
