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
      yq -Y --arg s "$dockersecret" \
        ' .ssp.global.ssp.registry.existingSecrets[0].name = $s
        | ."hazelcast-enterprise".image.pullSecrets[0] = $s
        '
