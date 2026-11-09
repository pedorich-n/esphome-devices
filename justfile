import "dev/justfile.default"

esphome *args:
    just _run esphome-with-secrets {{ args }}

compile config *args:
    just esphome compile {{ config }} {{ args }}

flash config *args:
    just esphome run {{ config }} {{ args }}

logs config *args:
    just esphome logs {{ config }} {{ args }}

clean-mqtt config *args:
    just esphome clean-mqtt {{ config }} {{ args }}

shell *args:
    just _develop "{{ args }}"
