#!/bin/bash
helm install grafana-op bitnami/grafana-operator -n monitoring -f grafanaop.yaml --version=2.7.3

