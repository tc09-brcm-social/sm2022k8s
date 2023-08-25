#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
# PROMETHEUSREL
    yq -Y --arg r "$PROMETHEUSREL" \
        ' .controller.metrics.enabled = true
        | .controller.metrics.serviceMonitor.enabled = true
        | .controller.metrics.serviceMonitor.additionalLabels.release = $r
        '
