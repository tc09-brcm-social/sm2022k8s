#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
GRAFANA_GID="$(kubectl get ns "${MONITORING}" -o yaml \
	        | yq -r '.metadata.annotations."openshift.io/sa.scc.supplemental-groups"' \
		        | cut -d/ -f1)"
GRAFANA_FSGROUP=${GRAFANA_GID}
 
    yq -Y --argjson g "${GRAFANA_GID}" \
        ' .operator.containerSecurityContext.runAsGroup = $g
        | .operator.podSecurityContext.fsGroup = $g
        | .grafana.podSecurityContext.fsGroup = $g
        '
#        | .operator.containerSecurityContext.runAsGroup=${GRAFANA_GID}
#        | .operator.podSecurityContext.fsGroup=${GRAFANA_FSGROUP}
#        | .grafana.podSecurityContext.fsGroup=${GRAFANA_FSGROUP}
#          .operator.containerSecurityContext.runAsUser=${GRAFANA_UID}
#        | .grafana.containerSecurityContext.runAsUser=${GRAFANA_UID}
#        | .grafana.podSecurityContext.runAsUser=${GRAFANA_UID}
