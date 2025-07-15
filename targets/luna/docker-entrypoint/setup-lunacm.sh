#!/bin/bash

if ! pushd /opt/luna > /dev/null 2>&1; then
    echo "ERROR: Directory /opt/luna not found"
    exit 1
fi

if [ -f "$LUNA_CONFIG_FILE" ]; then
  cat "$ChrystokiConfigurationPath/Chrystoki.conf.tpl" "$LUNA_CONFIG_FILE" > "$ChrystokiConfigurationPath/Chrystoki.conf"
else
  echo "ERROR: Config file not found at $LUNA_CONFIG_FILE"
  exit 1
fi

popd > /dev/null || exit
