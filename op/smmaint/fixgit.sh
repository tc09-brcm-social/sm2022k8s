#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}/../.."
. ./env.shlib
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
PAT="$(kubectl get secrets "$PSREL-siteminder" -n "$PSNS" -o json \
	| jq -r '.data.githubAccessToken')"
kubectl get secrets "$SMMAINTREL-siteminder-maintenance" -n "$PSNS" -o yaml \
    | yq -Y --arg p "$PAT" '.data.githubAccessToken = $p' \
    | kubectl apply -f -
