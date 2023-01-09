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
      yq -Y \
        ' .ssp.deployment.size = "demo"
        | ."hazelcast-enterprise".cluster.memberCount = 1
        '
