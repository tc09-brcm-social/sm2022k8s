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
SAURL="https://$SANAME/default/"
SACLIENTID="$(kubectl get secret ${SSPRELEASE}-ssp-secret-democlient \
    -n "${SSP}" -o jsonpath="{.data.clientId}" | base64 --decode)"
SACLIENTSECRET="$(kubectl get secret ${SSPRELEASE}-ssp-secret-democlient \
    -n "${SSP}" -o jsonpath="{.data.clientSecret}" | base64 --decode)"
      yq -Y --arg u "$SAURL" \
	 --arg i "$SACLIENTID" --arg s "$SACLIENTSECRET" \
        ' .ssp.serviceUrl = $u
        | .ssp.clientId = $i
        | .ssp.clientSecret = $s
        '
