#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. ./env.shlib
YAML="$$.yaml"
JSON='{ "min": "", "max": "" }'
min() {
    echo "$JSON" | jq -r '.min'
    }
max() {
    echo "$JSON" | jq -r '.max'
    }

minmax() {
    local tag="$1"
    if [[ ! -z "$tag" && "$tag" != "null" ]] ; then
	if [[ -z "$(min)" || "$tag" < "$(min)" ]] ; then
	    JSON="$(echo "$JSON" | jq --arg s "$tag" '.min = $s')"
        fi
	if [[ -z "$(max)" || "$tag" > "$(max)" ]] ; then
	    JSON="$(echo "$JSON" | jq --arg s "$tag" '.max = $s')"
        fi
    fi
    }
bash ../../envs/common/sc/rtvalues.sh > "$YAML"
LEN=$(echo "$TAGS" | jq 'length')
for (( i = 0; i < $LEN; ++i )); do
	minmax "$(yq -r "$(echo "$TAGS" | jq -r ".[$i]")" "$YAML")"
done
echo "$JSON" | jq '.'
