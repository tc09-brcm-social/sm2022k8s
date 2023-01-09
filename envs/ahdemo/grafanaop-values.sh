#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
bash ../common/prometheus/grafana-operator-value.sh \
    | bash ../common/prometheus/grafana-default.sh \
    | bash ../common/prometheus/grafana-ui.sh
