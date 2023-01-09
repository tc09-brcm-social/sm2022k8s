#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
bash ../common/prometheus/kube-prometheus-value.sh \
    | bash ../common/prometheus/alertmanager1.sh \
    | bash ../common/prometheus/storageclass.sh
