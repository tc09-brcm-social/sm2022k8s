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
TAG="$1"
if [[ -z "$TAG" ]] ; then
    >&2 echo "required tag not specified, failed"
    exit 1
else
    HELMSEARCH="$MYPATH/sc.$SMREPO.$$.json"
	helm search repo "$SMREPO" --versions -o json \
	    | jq '[.[] | select(.name == "'$SMREPO/server-components'")]' \
	    > "$HELMSEARCH"
	VER="$(jq -r '.[] | select(.app_version == "'$TAG'") | .version' "$HELMSEARCH")"
	echo '--version='"$VER"
fi
