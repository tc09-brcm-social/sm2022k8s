#!/bin/bash
i="$1"
    >&2 echo Setting StorageClass $i as default
    kubectl patch StorageClass "$i" \
	-p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
