#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
ELASTICPWD="$(kubectl get secret -n "$LOGGING" elasticsearch-es-elastic-user -o jsonpath='{.data.elastic}' | base64 -d)"
	# This is a build time function
    yq -Y --arg p "$ELASTICPWD" \
        ' .backend.es.host = "elasticsearch-es-http.logging.svc"
	| .backend.es.http_user = "elastic"
	| .backend.es.http_passwd = $p
	| .backend.es.tls = "on"
	| .backend.es.tls_verify = "off"
        '
