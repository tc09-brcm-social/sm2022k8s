#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
yq -Y --arg v "$SMTAG" \
    --arg n "$SMNEWTAG" \
    ' .admin.policyServer.tag = $n
    | .admin.adminUI.tag = $n
    | .admin.policyServer.xpsSchemaUpgrade = "YES"
    '
