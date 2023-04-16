#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
yq -Y \
    ' .global.acceptLicenseAgreement = "YES"
    | .global.fullname = "casso"
    | .global.policyServerParams.ovm.enabled = false
    | .global.restartPolicy = "Always"
    | .policyServer.enableRadiusServer = "NO"
    | .admin.adminUI.serviceChoice = "ingress"
    | .maintenance.job.restartPolicy = "Never"
    '
