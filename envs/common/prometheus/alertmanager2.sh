#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi

yq -Y --arg n "$ALERTMANAGERNAME" \
	--arg c "$(sed -ne '/BEGIN/,/END/p' "../../$MONITORINGPEM")" \
	--arg k "$(sed -ne '/BEGIN/,/END/p' "../../$MONITORINGKEY")" \
    '.alertmanager.ingress.enabled = true
    | .alertmanager.ingress.ingressClassName = "nginx"
    | .alertmanager.ingress.hostname = $n
    | .alertmanager.ingress.tls = true
    | .alertmanager.persistence.enabled = true
    | .alertmanager.ingress.secrets[0].name = ( $n + "-tls" )
    | .alertmanager.ingress.secrets[0].certificate = $c
    | .alertmanager.ingress.secrets[0].key = $k
    '
