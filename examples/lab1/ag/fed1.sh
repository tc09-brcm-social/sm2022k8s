#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../env.shlib"
    yq -Y \
        ' .sso.accessGateway.federationGateway.enabled = true
        | .sso.accessGateway.federationGateway.trace.enabled = true
        '
