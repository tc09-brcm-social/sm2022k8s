#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}/../.."
. ./env.shlib
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi

if [[ -z "$(repoexist "$SMREPO")" ]] ; then
    bash "${MYPATH}/../base/smrepo.sh"
else
    >&2 echo $SMREPO exists
fi
cd "${MYPATH}"
if [[ -f "./env.shlib" ]]; then
    . ./env.shlib
fi
VALUES="$1"
DESC="$2"
if [[ -z "$VALUES" ]] ; then
    >&2 echo "Required values.yaml file not specified, existing ..."
    exit 1
fi
if [[ ! -f "$VALUES" ]] ; then
    >&2 echo "Required values.yaml file not exist, existing ..."
    exit 2
fi
if [[ -z "$DESC" ]] ; then
   DESC="upgrade administrative server pod using file $VALUES"
fi
SCVALUES="$MYPATH/sc.$$.yaml"
bash "$MYPATH/../../envs/common/sc/rtvalues.sh" > "$SCVALUES"
if [[ ! "$(yq -r '.admin.enabled' "$SCVALUES")" == true ]] ; then
    >&2 echo "adminUI is not enabled, not to update, existing"
    exit 3
else
    TAG="$(yq -r '.admin.adminUI.tag' "$SCVALUES")"
    SMVER="$(bash "$MYPATH/hcversion.sh" "$TAG")"
    if [[ -z "$SMVER" ]] ; then
	>&2 "Unable to determine the helm chart version, existing ..."
	exit 4
    fi
    helm upgrade "$PSREL" "$SMREPO/server-components" -n "$PSNS" \
	-f "$VALUES" $SMVER \
        --description="$DESC" \
        --timeout=30m --wait --debug > "$PSVALUES".debug
fi
