#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
bash ../common/ssp/ssp-infra-backend.sh \
    | bash ../common/ssp/ssp-infra-sspfbService.sh
