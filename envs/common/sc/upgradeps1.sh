#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
yq -Y --arg v "$SMTAG" \
    --arg n "$SMNEWTAG" \
    ' .policyServer.tag = $n
    | .policyServer.metricsExporter.tag = $n
    | .global.configuration.tag = $n
    | .global.runtimeConfiguration.tag = $n
    | .admin.policyServer.tag = $v
    | .admin.adminUI.tag = $v
    '
