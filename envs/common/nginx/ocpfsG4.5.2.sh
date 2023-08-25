#/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../../base/$VERSHLIB"
fi
fsGroup="$(kubectl get ns "${INGRESS}" -o yaml \
	| yq -r '.metadata.annotations."openshift.io/sa.scc.uid-range"' \
	| cut -d/ -f1)"
    yq -Y --argjson g "$fsGroup" \
        ' .controller.admissionWebhooks.patch.securityContext.fsGroup = $g
        '
