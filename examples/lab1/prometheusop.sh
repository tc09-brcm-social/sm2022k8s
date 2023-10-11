#!/bin/bash
helm install prometheus-op bitnami/kube-prometheus -n monitoring -f prometheusop.yaml --version=8.1.9
