#!/bin/bash
kubectl delete elasticsearch elasticsearch -n logging
bash kibana-user.sh
kubectl apply -f elasticsearch.yaml
