#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
GRAFANA_UID="$(kubectl get ns "${MONITORING}" -o yaml \
	        | yq -r '.metadata.annotations."openshift.io/sa.scc.uid-range"' \
		        | cut -d/ -f1)"
 
    yq -Y --argjson u "$GRAFANA_UID" \
        ' .operator.containerSecurityContext.runAsUser = $u
        | .grafana.containerSecurityContext.runAsUser = $u
        | .grafana.podSecurityContext.runAsUser = $u
        '
#        | .operator.containerSecurityContext.runAsGroup=${GRAFANA_GID}
#        | .operator.podSecurityContext.fsGroup=${GRAFANA_FSGROUP}
#        | .grafana.podSecurityContext.fsGroup=${GRAFANA_FSGROUP}
