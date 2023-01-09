#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
bash ../common/ssp/ssp-infra-values.sh \
    | bash ../common/ssp/ssp-infra-default.sh \
    | bash ../common/ssp/ssp-infra-ssp-data.sh
