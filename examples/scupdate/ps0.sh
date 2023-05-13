#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
YAML="$$.yaml"
ENABLED="$(cat | tee "$YAML" | yq -r '.policyServer.enabled')"
    if [[ "$ENABLED" = true ]] ; then
	cat "$YAML" | yq -Y '.policyServer.enabled = false'
    fi
