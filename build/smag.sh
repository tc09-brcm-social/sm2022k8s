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

createns "$AGNS"

#
## Install SiteMinder Access Gateway chart
#
if [[ -z "$(relexist "$AGNS" "$AGREL")" ]] ; then
    cat "$AGVALUES" \
    | if [[ -z "$AGRTVALUES" ]] ; then cat - ; else \
          bash "$AGRTVALUES"
      fi \
    | tee $$.ag.yaml \
    |  helm install "$AGREL" -n ${AGNS} \
        $SMREPO/access-gateway $SMVER -f - \
        --debug > "$AGREL.$AGNS.$$.debug"
else
    >&2 echo release $AGREL exists, attempt to upgrade
    helm upgrade --install "$AGREL" -n ${AGNS} \
        $SMREPO/access-gateway $SMVER -f "$AGVALUES" \
        --debug > "$AGREL.$AGNS.$$.debug"
fi
