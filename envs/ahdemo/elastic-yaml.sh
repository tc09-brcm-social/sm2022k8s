#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. ./env.shlib
if [ -z "$ELASTICSC" ] ; then
    cat ../common/elastic/elasticsearch.yaml \
        | yq -Y \
	     'del(.spec.nodeSets[0].volumeClaimTemplates[0].spec.storageClassName)'
else
    cat ../common/elastic/elasticsearch.yaml \
        | yq -Y --arg n "$ELASTICSC" \
	     '.spec.nodeSets[0].volumeClaimTemplates[0].spec.storageClassName = $n'
fi
