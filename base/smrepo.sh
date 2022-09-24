#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
. "${MYPATH}/env.shlib"
if [[ -z "$(repoexist "$SMREPO")" ]] ; then
    helm repo add "$SMREPO" "$SMURL" \
	--username "$SMID" \
	--password "$SMPWD" \
	--pass-credentials  
else
    >&2 echo repo $SMREPO exists
fi
helm repo update
helm search repo "$SMREPO" --versions
