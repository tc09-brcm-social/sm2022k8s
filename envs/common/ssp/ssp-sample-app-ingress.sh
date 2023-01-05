#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
if [[ -z "$SANAME" ]] ; then
    SANAME="$(kubectl get ingress -n ${SSP} ${SSPRELEASE}-ssp-ingress -o jsonpath={.spec.rules[].host})"
fi
      yq -Y --arg h "$SANAME" --arg n "$SATLS" \
        ' .ingress.host = $h
        | .ingress.tls.host = $h
        | .ingress.tls.secretName = $n
        '
