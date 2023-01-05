#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
      yq -Y --arg h "$SSPNAME" --arg s "$SSPTLS"  \
        ' .ssp.ingress.host = $h
        | .ssp.ingress.tls.secretName = $s
        '
