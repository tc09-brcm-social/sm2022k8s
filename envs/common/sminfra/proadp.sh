#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
yq -Y --arg s "$PSNAME" \
    ' ."fluent-bit".enabled = false
    | ."prometheus-adapter".enabled = true
    '
