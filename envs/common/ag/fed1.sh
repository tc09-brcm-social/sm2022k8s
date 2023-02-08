#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
    yq -Y \
        ' .sso.accessGateway.federationGateway.enabled = true
        | .sso.accessGateway.federationGateway.trace.enabled = true
        '
