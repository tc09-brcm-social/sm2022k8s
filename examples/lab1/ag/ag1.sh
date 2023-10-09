#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../env.shlib"
    yq -Y --arg s "$AGNAME" \
        ' .sso.accessGateway.virtualHostnames = $s
        '
