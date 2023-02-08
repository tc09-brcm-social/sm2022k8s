#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
yq -Y --arg n "$SMNEWTAG" \
    ' .images.configuration.tag = $n
    | .images.runtime.configuration.tag = $n
    | .images.metricsExporter.tag = $n
    | .images.accessGateway.tag = $n
    '
