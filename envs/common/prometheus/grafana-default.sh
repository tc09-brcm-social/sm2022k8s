#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi

yq -Y --arg t "$GRAFANATAG" --arg p "$GRAFANAPWD" \
    '.operator.containerSecurityContext.readOnlyRootFilesystem = true
    | .grafana.image.tag = $t
    | .grafana.config.security.admin_password = $p
    '
