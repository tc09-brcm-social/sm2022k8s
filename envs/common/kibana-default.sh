#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi

if [[ "$KIBANAVER" == "--version 7.9.3" ]] ; then
    yq -Y --arg n "${KIBANANAME}" --arg s "${KIBANASECRET}" \
        '.ingress.enabled = true
	| .ingress.annotations = { "kubernetes.io/ingress.class" : "nginx" }
        | .ingress.hosts[0] = $n
        | .ingress.tls[0].secretName = $s
        | .ingress.tls[0].hosts[0] = $n
        '
elif [[ "$KIBANAVER" == "--version 7.16.3" ]] ; then
    yq -Y --arg n "${KIBANANAME}" --arg s "${KIBANASECRET}" \
        '.ingress.enabled = true
        | .ingress.className = "nginx"
        | .ingress.hosts[0].host = $n
        | .ingress.hosts[0].paths[0].path = "/"
        | .ingress.tls[0].secretName = $s
        | .ingress.tls[0].hosts[0] = $n
        '
fi
