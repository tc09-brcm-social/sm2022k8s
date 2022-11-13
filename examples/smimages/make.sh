#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}/../.."
. ./env.shlib
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
cd "${MYPATH}"
. ./env.shlib
buildIMAGELIST() {
    IMAGELIST="$(jaddToList "$IMAGELIST" "$FROMHOST/$FROMUSER/access-gateway:$IMAGEVER")"
    IMAGELIST="$(jaddToList "$IMAGELIST" "$FROMHOST/$FROMUSER/log-collector:$IMAGEVER")"
    IMAGELIST="$(jaddToList "$IMAGELIST" "$FROMHOST/$FROMUSER/config-retriever:$IMAGEVER")"
    IMAGELIST="$(jaddToList "$IMAGELIST" "$FROMHOST/$FROMUSER/policy-server:$IMAGEVER")"
    IMAGELIST="$(jaddToList "$IMAGELIST" "$FROMHOST/$FROMUSER/admin-ui:$IMAGEVER")"
    IMAGELIST="$(jaddToList "$IMAGELIST" "$FROMHOST/$FROMUSER/runtime-config-retriever:$IMAGEVER")"
    IMAGELIST="$(jaddToList "$IMAGELIST" "$FROMHOST/$FROMUSER/metricsexporter:$IMAGEVER")"
    IMAGELIST="$(jaddToList "$IMAGELIST" "$FROMHOST/$FROMUSER/agmetricsexporter:$IMAGEVER")"
    }
#
## Starts here
#
buildIMAGELIST
LEN=$(echo "$IMAGELIST" | jq 'length')
for (( i = 0; i < $LEN; ++i )); do
    echo "$IMAGELIST" | jq -r ".[$i]"
done
