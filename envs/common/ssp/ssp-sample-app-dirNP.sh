#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
      yq -Y \
        ' ."ssp-symantec-dir".service.type = "NodePort"
        | ."ssp-symantec-dir".service.servicePort = 389
        '
