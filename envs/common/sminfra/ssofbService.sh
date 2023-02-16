#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
RUNTIME="$(kubectl get nodes -o yaml | yq -r '.items[0].status.nodeInfo.containerRuntimeVersion')"
if [[ "$RUNTIME" = *containerd* || "$RUNTIME" = *cri-o* ]] ; then
    yq -Y \
        ' .ssofbService.parser = "cri"
        '
else
    cat -
fi
