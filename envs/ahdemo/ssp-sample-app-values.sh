#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
bash ../common/ssp/ssp-sample-app-values.sh \
    | bash ../common/ssp/ssp-sample-app-default.sh \
    | bash ../common/ssp/ssp-sample-app-dirLB.sh
