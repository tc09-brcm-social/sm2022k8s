#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
bash ../common/ssp/ssp-values.sh \
    | bash ../common/ssp/ssp-default.sh \
    | bash ../common/ssp/ssp-ingress.sh \
    | bash ../common/ssp/ssp-swagger1.sh
