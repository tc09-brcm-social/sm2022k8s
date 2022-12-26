#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi

yq -Y --arg n "$GRAFANANAME" --arg s "$GRAFANASECRET" \
    '.grafana.ingress.enabled = true
    | .grafana.ingress.ingressClassName = "nginx"
    | .grafana.ingress.hostname = $n
    | .grafana.ingress.tls = true
    | .grafana.ingress.tlsSecret = $s
    '
