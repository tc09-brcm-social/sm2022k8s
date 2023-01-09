#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
. ./env.shlib
    cat ../common/prometheus/grafana-datasource.yaml
