#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. ./env.shlib
YAML="$$.yaml"
bash ../../envs/common/sc/rtvalues.sh | \
    bash "$MYPATH/$UPDATE" > "$YAML"
if [[ -s "$YAML" ]]; then
    cat "$YAML" | \
        bash ../../op/sc/update.sh - "update server component using $UPDATE script"
else
    >&2 echo "empty yaml output, server component update skipped"
fi
