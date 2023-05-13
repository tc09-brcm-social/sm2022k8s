#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
YAML="$$.yaml"
ENABLED="$(cat | tee "$YAML" | yq -r '.admin.enabled')"
    if [[ "$ENABLED" = true ]] ; then
	cat "$YAML" | yq -Y '.admin.enabled = false'
    fi
