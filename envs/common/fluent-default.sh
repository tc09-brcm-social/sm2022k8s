#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
    yq -Y --arg n "${SSORELEASENAME}" \
        '."prometheus-adapter".enabled = false
        | ."fluent-bit".enabled = true
        | .ssoReleaseName = $n
	'
