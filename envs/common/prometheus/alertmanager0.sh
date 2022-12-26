#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi

yq -Y --arg s "$ALERTMANAGERNAME" \
    '.alertmanager.ingress.enabled = true
    | .alertmanager.ingress.ingressClassName = "nginx"
    | .alertmanager.ingress.hostname = $s
    | .alertmanager.ingress.tls = true
    | .alertmanager.ingress.selfSigned = true
    '
