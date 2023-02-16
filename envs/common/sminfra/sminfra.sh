#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
yq -Y --arg s "$PSREL" \
    ' ."fluent-bit".enabled = true
    | ."prometheus-adapter".enabled = false
    | .ssoReleaseName = $s
    '
