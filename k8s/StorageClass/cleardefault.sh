#!/bin/bash
for i in $(kubectl get StorageClass | grep '(default)' | cut -f1 -d' '); do
    >&2 echo unsetting StorageClass $i as default
    kubectl patch StorageClass "$i" \
	-p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
done
