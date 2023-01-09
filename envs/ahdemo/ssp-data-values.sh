#!/bin/bash
MYPATH=$(cd $(dirname "$0"); pwd)
cd "${MYPATH}"
bash ../common/ssp/ssp-data-values.sh \
    | bash ../common/ssp/ssp-data-default.sh
