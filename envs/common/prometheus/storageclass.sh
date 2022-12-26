#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi

if [[ -z "$PROMETHEUSSC" ]] ; then cat - ; else \
    yq -Y --arg s "$PROMETHEUSSC" \
        '.global.storageClass = $s'
fi
