#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}/../.."
. ./env.shlib
cd "${MYPATH}"
. "${MYPATH}/../../base/env.shlib"
if [[ ! -z "$VERSHLIB" ]] ; then
    . "${MYPATH}/../../base/$VERSHLIB"
fi
kubectl get pods -n "$SMINFRANS" -o json | \
	jq --arg n "$SMINFRANS" '[ .items[] | select(.metadata.name | contains("infra")) |
        { "name": .metadata.name,
	  "ns": $n,
	  "phase": .status.phase,
	  "containerStatus": ([.status.containerStatuses[]| {"name" : .name, "state" : .state }]),
	  "node": .spec.nodeName }
	]'
#	  "initContainerStatus": ([.status.initContainerStatuses[]| {"name" : .name, "state" : .state }]),
