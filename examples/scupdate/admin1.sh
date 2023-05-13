#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
YAML="$$.yaml"
ENABLED="$(cat | tee "$YAML" | yq -r '.admin.enabled')"
    if [[ "$ENABLED" = false ]] ; then
	cat "$YAML" | yq -Y '.admin.enabled = true'
    fi
