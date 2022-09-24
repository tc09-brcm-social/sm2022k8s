#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. "${MYPATH}/../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../base/$VERSHLIB"
fi

if [[ -z "$(repoexist "$SMREPO")" ]] ; then
    bash "${MYPATH}/../base/smrepo.sh"
else
    >&2 echo $SMREPO exists
fi

createns "$PSNS"

#
## Install SiteMinder Server Components chart
#
if [[ -z "$(relexist "$PSNS" "$PSREL")" ]] ; then
    helm install "$PSREL" -n ${PSNS} \
        $SMREPO/server-components $SMVER -f "$PSVALUES" \
	--debug > "$PSREL.$PSNS.$$.debug"
#        $SMREPO/server-components --set admin.enabled=true \
#        --set policyServer.enabled=true -f "$PSVALUES"
# kubectl get all -n ${SERVER_NAMESPACE}
# kubectl get pods -n ${SERVER_NAMESPACE}
# kubectl describe pod <POD-NAME> -n ${SERVER_NAMESPACE}
#Verify the deployment status of the pods
# kubectl logs <POD-NAME> -n ${SERVER_NAMESPACE} -c policy-server
#To know the Administrative UI service hostname and IP address, run below commands: kubectl get ing -n ${SERVER_NAMESPACE}
else
    >&2 echo release $PSREL exists, attempt to upgrade
    helm upgrade --install "$PSREL" -n ${PSNS} \
        $SMREPO/server-components $SMVER -f "$PSVALUES" \
        --debug > "$PSREL.$PSNS.$$.debug"
fi
