#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
bash ../common/ssp/ssp-sample-app-ingress.sh \
    | bash ../common/ssp/ssp-sample-app-service.sh
