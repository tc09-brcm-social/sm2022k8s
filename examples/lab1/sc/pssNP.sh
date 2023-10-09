#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../env.shlib"
yq -Y \
    '.global.policyServerParams.smTrace.enabled = true
    | .global.policyServerParams.inMemoryTrace.enabled = false
    | .global.policyServerParams.service.type = "NodePort"
    '
