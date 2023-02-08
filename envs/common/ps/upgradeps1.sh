#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
yq -Y --arg v "$SMTAG" \
    --arg n "$SMNEWTAG" \
    --argjson r "$ADMINS" \
    ' .policyServer.tag = $n
    | .global.configuration.tag = $n
    | .global.runtimeConfiguration.tag = $n
    | .global.metricsExporter.tag = $n
    | .admin.policyServer.tag = $v
    | .admin.adminUI.tag = $v
    | .admin.replicas = $r
    '
