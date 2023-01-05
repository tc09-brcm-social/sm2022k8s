#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
if [[ -z "$SSPDOCKERSECRET" ]] ; then
    dockersecret="ssp-registrypullsecret"
else
    dockersecret="$SSPDOCKERSECRET"
fi
bash "$MYPATH/ssp-infra-demodb.sh" \
    | yq -y --arg r "$SSPRELEASE" --arg s "$dockersecret" \
        '.sspReleaseName = $r
        | .ssp.global.ssp.registry.existingSecrets[0].name = $s
        '
