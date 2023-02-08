#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}/../.."
. ./env.shlib
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
kubectl get pods -n "$AGNS" -o json | \
    jq --arg n "$AGNS" '[ .items[] | 
        { "name": .metadata.name,
	  "ns": $n,
	  "phase": .status.phase,
	  "containerStatus": ([.status.containerStatuses[]| {"name" : .name, "state" : .state }]),
	  "initContainerStatus": ([.status.initContainerStatuses[]| {"name" : .name, "state" : .state }]),
	  "node": .spec.nodeName }
	]'
