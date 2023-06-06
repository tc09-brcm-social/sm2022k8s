#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
yq -Y \
    '.admin.enabled = true
    | .admin.policyServer.agentKeyGeneration.enabled = true
    | .admin.policyServer.keyUpdate.enabled = true
    '
