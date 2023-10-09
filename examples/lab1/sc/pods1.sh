#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../env.shlib"
yq -Y \
    ' .policyServer.enabled = true
    | .admin.enabled = true
    | .admin.policyServer.agentKeyGeneration.enabled = true
    | .admin.policyServer.keyUpdate.enabled = false
    '
