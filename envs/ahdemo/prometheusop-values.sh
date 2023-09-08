#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
echo '{}' \
    | bash ../common/prometheus/kube-prometheus-default.sh \
    | bash ../common/prometheus/alertmanager2.sh \
    | bash ../common/prometheus/storageclass.sh
