#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
SM_UID="$(kubectl get ns "${AGNS}" -o yaml \
	| yq -r '.metadata.annotations."openshift.io/sa.scc.uid-range"' \
	| cut -d/ -f1)"
SM_GID="$(kubectl get ns "${AGNS}" -o yaml \
	| yq -r '.metadata.annotations."openshift.io/sa.scc.supplemental-groups"' \
	| cut -d/ -f1)"
    yq -Y --argjson g "$SM_GID" --argjson u "$SM_UID" \
        ' .global.securityContext.runAsUser = $u
        | .global.securityContext.fsGroup = $g
        | .global.securityContext.runAsGroup = $g
        '
